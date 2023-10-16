module "S3" {
    source = "../../modules/S3"

    CF_arn = module.Cloudfront.CF_arn
}

module "Cloudfront" {
    source = "../../modules/Cloudfront"

    S3_id = module.S3.S3_bucket_id
    S3_domain_name = module.S3.S3_domain_name
}

