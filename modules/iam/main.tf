data "aws_caller_identity" "current" {}

resource "aws_iam_user" "user" {
  name = var.iam_user_name
}

resource "aws_iam_policy" "policies" {
  for_each    = var.iam_policies
  name        = each.key
  description = "IAM policy for ${each.key}"
  policy      = templatefile("${path.module}/${each.value}", {
    resource_arn = var.resource_arn_mapping[each.key]
  })
}

resource "aws_iam_user_policy_attachment" "policy_attachments" {
  for_each   = var.user_policy_mapping
  user       = aws_iam_user.user.name
  policy_arn = aws_iam_policy.policies[each.key].arn
}

resource "aws_iam_role" "role" {
  count = var.iam_role_name != "" && length(var.trusted_services) > 0 ? 1 : 0

  name = var.iam_role_name

  assume_role_policy = jsonencode({
    Version   = "2012-10-17",
    Statement = [
      {
        Effect    = "Allow",
        Action    = "sts:AssumeRole",
        Principal = {
          Service = var.trusted_services
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "role_policy_attachments" {
  for_each = length(var.role_policy_mapping) > 0 && length(aws_iam_role.role) > 0 ? var.role_policy_mapping : {}

  role       = aws_iam_role.role[0].name
  policy_arn = aws_iam_policy.policies[each.key].arn
}
