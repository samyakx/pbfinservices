output "website_url" {
  description = "Public HTTP URL of the hosted website"
  value       = "http://${aws_s3_bucket_website_configuration.website.website_endpoint}"
}

output "website_endpoint" {
  description = "S3 website hosting endpoint"
  value       = aws_s3_bucket_website_configuration.website.website_endpoint
}

output "bucket_name" {
  description = "Name of the created S3 bucket"
  value       = aws_s3_bucket.website.id
}

output "bucket_arn" {
  description = "ARN of the created S3 bucket"
  value       = aws_s3_bucket.website.arn
}

output "deployed_files" {
  description = "List of files uploaded to the S3 bucket"
  value       = keys(aws_s3_object.site_assets)
}
