output "S3_bucket_id" {
  value = aws_s3_bucket.terra.id
}

output "S3_domain_name" {
value = aws_s3_bucket.terra.bucket_regional_domain_name
}