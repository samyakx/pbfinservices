# ==============================================================================
# S3 BUCKET CONFIGURATION FOR STATIC WEBSITE HOSTING
# ==============================================================================

# 1. Primary S3 Bucket
resource "aws_s3_bucket" "website" {
  bucket        = var.bucket_name
  force_destroy = true

  tags = {
    Name        = var.bucket_name
    Environment = var.environment
  }
}

# 2. Bucket Ownership Controls
resource "aws_s3_bucket_ownership_controls" "website" {
  bucket = aws_s3_bucket.website.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

# 3. Disable Public Access Block (Allows Public Website Reading)
resource "aws_s3_bucket_public_access_block" "website" {
  bucket = aws_s3_bucket.website.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# 4. S3 Static Website Hosting Configuration
resource "aws_s3_bucket_website_configuration" "website" {
  bucket = aws_s3_bucket.website.id

  index_document {
    suffix = var.index_document
  }

  error_document {
    key = var.error_document
  }
}

# 5. Public Read Bucket Policy for Website
resource "aws_s3_bucket_policy" "public_read" {
  bucket = aws_s3_bucket.website.id

  depends_on = [
    aws_s3_bucket_public_access_block.website,
    aws_s3_bucket_ownership_controls.website
  ]

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.website.arn}/*"
      }
    ]
  })
}

# ==============================================================================
# AUTOMATED WEBSITE ASSET UPLOAD
# ==============================================================================

locals {
  # MIME type mappings to ensure browsers render files properly
  mime_types = {
    "html" = "text/html"
    "htm"  = "text/html"
    "css"  = "text/css"
    "js"   = "application/javascript"
    "json" = "application/json"
    "png"  = "image/png"
    "jpg"  = "image/jpeg"
    "jpeg" = "image/jpeg"
    "svg"  = "image/svg+xml"
    "ico"  = "image/x-icon"
    "md"   = "text/markdown"
    "txt"  = "text/plain"
  }

  # Website assets from root directory to deploy into S3
  site_files = fileset("${path.module}/..", "{*.html,*.png,*.jpg,*.jpeg,*.svg,*.css,*.js,*.json,*.md}")
}

# 6. Upload website files to S3 bucket
resource "aws_s3_object" "site_assets" {
  for_each = local.site_files

  bucket       = aws_s3_bucket.website.id
  key          = each.value
  source       = "${path.module}/../${each.value}"
  etag         = filemd5("${path.module}/../${each.value}")
  content_type = lookup(local.mime_types, lower(element(split(".", each.value), length(split(".", each.value)) - 1)), "binary/octet-stream")

  depends_on = [
    aws_s3_bucket_public_access_block.website,
    aws_s3_bucket_policy.public_read
  ]
}
