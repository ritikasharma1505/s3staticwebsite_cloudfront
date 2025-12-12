## Detailed explanation of main.tf file

### S3 Bucket (Private Website Storage)

```
resource "aws_s3_bucket" "site" {
  bucket = var.bucket_name
}

```

- Creates an S3 bucket to store your website files.

```
resource "aws_s3_bucket_public_access_block" "block" {
  bucket = aws_s3_bucket.site.id

  block_public_policy     = true
  block_public_acls       = true
  restrict_public_buckets = true
  ignore_public_acls      = true
}

```

- This keeps your bucket fully private.

- No one on the internet can access it directly.

- Prevents accidental public access.

```
resource "aws_s3_object" "index" {
  bucket       = aws_s3_bucket.site.id
  key          = "index.html"
  source       = var.index_file
  content_type = "text/html"
}

```

- Uploads your index.html to the bucket.

- Same for error.html

### CloudFront OAC (Origin Access Control)

```
resource "aws_cloudfront_origin_access_control" "oac" {
  name                              = "${var.bucket_name}-oac"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}
```

- CloudFront wants to pull files from S3, but S3 is private.

- So CloudFront needs a “passport” to prove itself.

- This passport = OAC

Breakdown:

- origin_type = "s3" -> OAC is meant to access S3.

- signing_behavior = "always" -> CloudFront always signs requests.

- signing_protocol = "sigv4" -> AWS signature version 4 is used (security method).

- OAC replaces old OAI. It’s more secure and the newest AWS method.

### CloudFront Distribution (Main Component)

```
resource "aws_cloudfront_distribution" "cdn" {
  enabled             = true
  default_root_object = "index.html"
}
```

- Creates a CloudFront CDN.

- When someone goes to your site, CloudFront serves index.html

```
origin {
  domain_name              = aws_s3_bucket.site.bucket_regional_domain_name
  origin_id                = "s3origin"
  origin_access_control_id = aws_cloudfront_origin_access_control.oac.id
}
```

- CloudFront needs to know where your files are -> S3 bucket.

- domain_name points to your bucket.

- origin_id is just a label/ID.

- origin_access_control_id connects CloudFront to S3 using OAC.

- Without this, CloudFront cannot read your files.

```
default_cache_behavior {
  target_origin_id       = "s3origin"
  viewer_protocol_policy = "redirect-to-https"

  allowed_methods  = ["GET", "HEAD"]
  cached_methods   = ["GET", "HEAD"]
  forwarded_values {
    query_string = false
  }
}

```

- Defines how CloudFront behaves for requests.

- viewer_protocol_policy = redirect-to-https -> always forces HTTPS.

- allowed_methods = GET, HEAD -> perfect for static sites.

- cached_methods-> these methods are cached by CloudFront.

- query_string = false -> CloudFront ignores ?query=params.

```
custom_error_response {
  error_code         = 404
  response_code      = 200
  response_page_path = "/error.html"
}
```

- If someone opens a wrong URL (404), CloudFront shows your custom error.html

```
viewer_certificate {
  cloudfront_default_certificate = true
}

```
- CloudFront uses its own default HTTPS certificate.


### S3 Bucket Policy (Allow Only CloudFront Access)

```
resource "aws_s3_bucket_policy" "policy" {
  bucket = aws_s3_bucket.site.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "cloudfront.amazonaws.com"
      },
      Action   = "s3:GetObject",
      Resource = "${aws_s3_bucket.site.arn}/*",
      Condition = {
        StringEquals = {
          "AWS:SourceArn" = aws_cloudfront_distribution.cdn.arn
        }
      }
    }]
  })
}
```

- Think of this like a door rule:

- 'Only CloudFront (not users) can enter this S3 bucket'

Breakdown:

- Principal = cloudfront.amazonaws.com -> Only CloudFront is allowed.

- s3:GetObject -> Only allowed action.

- Resource = S3 objects -> All files in bucket.

Condition:

- Only this CloudFront distribution is allowed (extra security).

- This ensures:
- No one can reach S3 directly
- Only CloudFront can

- This is best practice.