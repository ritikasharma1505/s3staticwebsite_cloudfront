## AWS S3 + CloudFront Static Website Hosting using Terraform(IaC) Overview

- Built and deployed a fully automated static website hosting architecture using Terraform (IaC).

- Provisioned a private S3 bucket to store website content (index.html, error.html) with secure access controls.

- Configured CloudFront CDN with an Origin Access Control (OAC) to serve content globally while keeping the S3 bucket completely private.

- Implemented CloudFront caching, HTTPS enforced redirects, custom error pages, and optimized global delivery.

- Automated resource creation including S3 objects, CloudFront distribution, bucket policies, and origin configuration through Terraform.

- Output the CloudFront domain name automatically for seamless deployment.

- Followed AWS security best practices by blocking all public access to S3 and allowing only CloudFront to read objects.

---------------------------------------------------------------------------------------------------------------

How It Works (Request Flow)

User opens your site -
- CloudFront receives request
- If cached -> responds instantly
- If not cached -> CloudFront goes to S3
- Uses OAC to authenticate
- S3 returns object
- CloudFront caches it
- CloudFront sends it to user

S3 is never public.

-------------------------------------------------------------------------------------

Step by step guide: 

📌 Prerequisites

- Create an EC2 instance (Ubuntu preferred).

- Connect to the instance using SSH.

- Run "terraform-install.sh" bash script to install:

  1. Terraform

  2. AWS CLI

- In the AWS Console, create an IAM Access Key.

- Configure the CLI on your EC2 instance:

```
aws configure
```

*This stores your AWS credentials so Terraform can create resources*


📂 Set Up the Terraform Project

### Inside your project folder, create the following files:

1. main.tf

2. provider.tf

3. variables.tf

4. outputs.tf

5. index.html

6. error.html

*Make sure the two HTML files are in the same folder as the Terraform files*

### This Terraform code will:

- Create a private S3 bucket

- Upload your website files

- Create a CloudFront distribution

- Use OAC (Origin Access Control) for secure access

- Output your CloudFront website URL

🚀 Deploy the Infrastructure

- Run the following commands:

```
terraform init
terraform plan
terraform apply
```

*Terraform will show you a preview (plan) and then create everything (apply)*

- After apply completes, Terraform will output a CloudFront URL.

🌐 Your Website Is Live!

- Open the CloudFront URL in your browser — your portfolio website is now hosted securely on:

1. Amazon S3 (for storage)

2. CloudFront CDN (for global delivery)

### This setup gives:

- Faster website performance

- Better security (S3 stays private)

- HTTPS support

- Custom error pages

Last and final STEP : CLEANUP resources !!!

```
terraform destroy
```

******************************************

