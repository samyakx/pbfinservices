variable "aws_region" {
  description = "AWS Region to deploy the S3 static website"
  type        = string
  default     = "ap-south-1" # Asia Pacific (Mumbai)
}

variable "bucket_name" {
  description = "Globally unique name for the S3 bucket"
  type        = string
  default     = "pbfinancialservices"
}

variable "environment" {
  description = "Deployment environment name"
  type        = string
  default     = "production"
}

variable "index_document" {
  description = "Default document to serve for website root requests"
  type        = string
  default     = "index.html"
}

variable "error_document" {
  description = "Error document to serve for 404 or errors"
  type        = string
  default     = "index.html"
}
