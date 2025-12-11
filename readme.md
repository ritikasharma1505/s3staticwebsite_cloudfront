## AWS S3 + CloudFront Static Website Hosting using Terraform

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



