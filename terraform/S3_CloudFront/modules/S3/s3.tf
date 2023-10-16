#Create S3bucket
resource "aws_s3_bucket" "terra" {
  bucket = var.URL

  tags = {
    Name        = var.URL
    Environment = "Dev"
  }
}

resource "aws_s3_bucket_website_configuration" "terra" {
  bucket = aws_s3_bucket.terra.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "index.html"
  }
}

#Copy index.html & stylesheet.css
# locals {
#   path = {
#     "index.html" = "source/index.html"
#     "stylesheet.css" = "spurce/stylesheet.css"
#   }
# }
# resource "aws_s3_object" "object" {
#   for_each = local.path

#   bucket = aws_s3_bucket.terra.id
#   key    = each.key
#   source = each.value

  # The filemd5() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the md5() function and the file() function:
  # etag = "${md5(file("path/to/file"))}"
  #etag = filemd5(each.value)
#}

#Create s3_bucket_acl
# resource "aws_s3_bucket_acl" "terra" {
#   bucket = aws_s3_bucket.terra.id
#   acl    = "private"
# }

#Create S3_bucket_policy
resource "aws_s3_bucket_policy" "terra" {
  depends_on = [
    aws_s3_bucket.terra,
  ]
  bucket = aws_s3_bucket.terra.id
  policy = data.aws_iam_policy_document.terra.json
}

#Create S3_bucket_policy
data "aws_iam_policy_document" "terra" {
  statement {
    sid = "Allow CloudFront"
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }

    actions = [
      "s3:GetObject",
    ]

    resources = [
      "${aws_s3_bucket.terra.arn}/*",
    ]
    condition {
      test     = "StringEquals"
      variable = "aws:SourceArn"
      values   = [var.CF_arn]
    }
  }
}
