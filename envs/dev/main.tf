
module "secrets_manager" {
  source        = "../../modules/secrets"
  secret_name   = var.secret_name
  description   = var.secret_description
  secret_values = var.secret_values
}

module "ec2" {
  source        = "../../modules/ec2"
  instance_type = var.instance_type
  key_name      = var.key_name
  instance_name = var.instance_name
  environment   = var.environment
  security_group_id = module.sg.sg_id
  jenkins_pub_key = var.jenkins_pub_key
  EC2_USER_DATA = var.EC2_USER_DATA
  iam_instance_profile_name = module.iam_backend.instance_profile_name


}

module "ecr" {
  source = "../../modules/ecr"

  repository_name      = var.ecr_repository_name
  scan_on_push         = var.ecr_scan_on_push
  image_tag_mutability = var.ecr_image_tag_mutability
  tags = {
    Environment = var.environment
    Project     = var.project
  }
}

module "my_s3_bucket" {
  source                     = "../../modules/s3"
  bucket_name                = var.bucket_name
  cloudfront_distribution_id = module.cdn.cloudfront_distribution_id
  iam_user_name              = module.iam_frontend.iam_user_name
  iam_user_arn               = module.iam_frontend.iam_user_arn
  policy_type                = var.policy_type

}

module "cdn" {

  source                      = "../../modules/cdn"
  bucket_regional_domain_name = module.my_s3_bucket.bucket_regional_domain_name
  custom_domain_name          = var.custom_domain_name
  acm_certificate_arn         = var.acm_certificate_arn
}

module "iam_backend" {
  source           = "../../modules/iam"
  iam_user_name    = var.iam_user_name_backend
  iam_role_name    = var.iam_role_name_backend
  trusted_services = var.trusted_services

  iam_policies = {
    "jenkins-user-policy"   = "policies/jenkins-user-policy.json",
    "secret-manager-policy" = "policies/secret-manager-policy.json",
    "ecr-read-policy"       = "policies/ecr-read-policy.json"
  }

  user_policy_mapping = {
    "jenkins-user-policy"   = module.ecr.repository_arn 
    "secret-manager-policy" = module.secrets_manager.secret_arn
  }

  role_policy_mapping = {
    "ecr-read-policy"       = module.ecr.repository_arn
  }


  resource_arn_mapping = {
    "jenkins-user-policy"   = module.ecr.repository_arn
    "secret-manager-policy" = module.secrets_manager.secret_arn
    "ecr-read-policy"       = module.ecr.repository_arn
  }
}


module "iam_frontend" {
  source        = "../../modules/iam"
  iam_user_name = var.iam_user_name_frontend


  iam_policies = {
    "s3_policy"  = "policies/s3_policy.json",
    "cdn_policy" = "policies/cdn_policy.json",

  }



  user_policy_mapping = {
    "s3_policy"  = module.my_s3_bucket.bucket_arn,
    "cdn_policy" = module.cdn.cdn_arn
  }

  resource_arn_mapping = {
    "s3_policy"  = module.my_s3_bucket.bucket_arn,
    "cdn_policy" = module.cdn.cdn_arn
  }
}

module "sg" {
  source        = "../../modules/sg"
  sg_name       = var.sg_name
  sg_description = var.sg_description
  ingress_rules = var.ingress_rules
}

module "route53" {
  source      = "../../modules/route53"
  zone_name   = var.zone_name
  record_name = var.record_name
  record_type = var.record_type
  ttl         = var.ttl
  records     = var.records
}

