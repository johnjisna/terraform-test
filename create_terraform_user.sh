#!/bin/bash

set -e

# Prompt for IAM user name and S3 bucket name
read -p "Enter IAM user name: " IAM_USER_NAME
read -p "Enter S3 bucket name for Terraform backend: " S3_BUCKET_NAME


# Policy names
CUSTOM_POLICY_NAME="TerraformFullAccessPolicy"
S3_POLICY_NAME="S3BackendAccessPolicy"


# Files
CUSTOM_POLICY_FILE="terraform_policy.json"
S3_POLICY_FILE="terraform_s3_backend_policy.json"


# Step 1: Create the S3 bucket
echo "Creating S3 bucket: $S3_BUCKET_NAME"
aws s3api create-bucket --bucket "$S3_BUCKET_NAME"


# Step 2: Create the IAM user
echo "Creating IAM user: $IAM_USER_NAME"
aws iam create-user --user-name "$IAM_USER_NAME"


# Step 3: Create the S3 backend access policy file dynamically
cat > $S3_POLICY_FILE <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:ListBucket"
      ],
      "Resource": "arn:aws:s3:::$S3_BUCKET_NAME"
    },
    {
      "Effect": "Allow",
      "Action": [
        "s3:GetObject",
        "s3:PutObject",
        "s3:DeleteObject"
      ],
      "Resource": "arn:aws:s3:::$S3_BUCKET_NAME/*"
    }
  ]
}
EOF

echo "S3 backend access policy created: $S3_POLICY_FILE"


# Step 4: Attach the custom Terraform policy
echo "Attaching Terraform policy..."
aws iam put-user-policy \
  --user-name "$IAM_USER_NAME" \
  --policy-name "$CUSTOM_POLICY_NAME" \
  --policy-document file://$CUSTOM_POLICY_FILE


# Step 5: Attach the S3 backend policy
echo "Attaching S3 backend access policy..."
aws iam put-user-policy \
  --user-name "$IAM_USER_NAME" \
  --policy-name "$S3_POLICY_NAME" \
  --policy-document file://$S3_POLICY_FILE


# Step 6: Generate access keys
echo "Generating access keys..."
aws iam create-access-key --user-name "$IAM_USER_NAME" > access-keys.json

echo "Access keys saved to access-keys.json"
echo "Done"
