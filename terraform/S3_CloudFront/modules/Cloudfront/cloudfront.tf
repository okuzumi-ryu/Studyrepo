#Create cloudfront_distribution
resource "aws_cloudfront_distribution" "terra" {
  origin {
    domain_name              = var.S3_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.terra.id
    origin_id                = var.S3_id
  }

  enabled             = true
  is_ipv6_enabled     = false
  #comment             = "Some comment"
  default_root_object = "index.html"

  #デフォルトキャッシュビヘイビアの設定
  default_cache_behavior {
    allowed_methods  = [ "GET", "HEAD" ]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = var.S3_id

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }
  #地理的制限設定（設定する場合はwhitelist or blacklistで設定）
  restrictions {
    geo_restriction {
      restriction_type = "none"
      #locations        = ["none"]
    }
  }

  tags = {
    Environment = "dev"
  }
  #作成したACMと紐づけてSSL化（先にACM作成したときにでるoutputからコピー）
  viewer_certificate {
    cloudfront_default_certificate = true
    #acm_certificate_arn      ="var.ACM_cert"
    acm_certificate_arn      = var.ACM_arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1"
  }
  aliases = ["${var.URL}"]
}

#OACの作成（OAIは古くOACが推奨）
resource "aws_cloudfront_origin_access_control" "terra" {
  name                              = "${var.URL}-oac"
  description                       = "Policy"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}


#Set own DNS data
data "aws_route53_zone" "terra" {
  name         = "${var.URL}"
  private_zone = false
}
#Route53のレコード作成（cloudfrontとドメイン紐づけ）
resource "aws_route53_record" "terra" {
  zone_id = data.aws_route53_zone.terra.zone_id
  name    = var.URL
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.terra.domain_name
    zone_id                = aws_cloudfront_distribution.terra.hosted_zone_id
    evaluate_target_health = true
  }
}