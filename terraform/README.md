# Terraform S3 Static Website Infrastructure

Production-ready Terraform configuration to deploy the **P B Financial Services** static website to an Amazon Web Services (AWS) S3 bucket configured for public static website hosting.

---

## 📁 Architecture & File Layout

```
pbfinservices/
├── index.html                   # Main landing page
├── calculator.html              # SIP & Wealth Planner page
├── screenshot.png               # Visual asset
├── design.md                    # Architecture & design specs
└── terraform/
    ├── providers.tf             # AWS provider (~> 5.0) & Terraform version
    ├── variables.tf             # Region, bucket name, and document settings
    ├── main.tf                  # S3 bucket, public policy, website config & asset sync
    ├── outputs.tf               # Public website URL and bucket ARN outputs
    ├── terraform.tfvars.example # Sample variables file
    └── README.md                # Deployment documentation
```

---

## 🚀 Deployment Instructions

### 1. Prerequisites

Ensure your AWS credentials are configured on your machine:
```bash
aws configure
# Enter your AWS Access Key ID
# Enter your AWS Secret Access Key
# Default region: ap-south-1 (or your preferred region)
# Default output format: json
```

### 2. Initialize Terraform

Navigate to the `terraform` directory and initialize the AWS provider plugins:
```bash
cd terraform
terraform init
```

### 3. Review Plan

Inspect the resources that Terraform will create:
```bash
terraform plan
```

> **Note on S3 Bucket Names**: S3 bucket names are globally unique across all AWS accounts worldwide.
> The default bucket name is configured as `pbfinancialservices`. If that name is already claimed by another AWS user, you can override it:
> ```bash
> terraform plan -var="bucket_name=pbfinancialservices-prod"
> ```
> Or copy `terraform.tfvars.example` to `terraform.tfvars` and edit `bucket_name`.

### 4. Apply & Deploy

Deploy the S3 bucket, configure public read access, and automatically sync your website files:
```bash
terraform apply
```
Type `yes` when prompted.

---

## 🌐 Accessing Your Website

When `terraform apply` finishes, it will print your live website URL in the outputs:
```
Outputs:

bucket_arn       = "arn:aws:s3:::pbfinancialservices"
bucket_name      = "pbfinancialservices"
deployed_files   = [
  "calculator.html",
  "design.md",
  "index.html",
  "screenshot.png"
]
website_endpoint = "pbfinancialservices.s3-website.ap-south-1.amazonaws.com"
website_url      = "http://pbfinancialservices.s3-website.ap-south-1.amazonaws.com"
```

Open `website_url` in your browser to view your live site!

---

## 🔄 Updating Website Content

Whenever you modify `index.html` or `calculator.html`, re-run:
```bash
terraform apply
```
Terraform automatically computes MD5 checksums (`etag`) of all files in the root folder and uploads only modified or added assets with the correct MIME types (`text/html`, `image/png`, etc.).

---

## 🧹 Destroying Resources

If you ever wish to decommission the website and delete the S3 bucket:
```bash
terraform destroy
```
Type `yes` to confirm.
