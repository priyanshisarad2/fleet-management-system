########     Cloudfront with Load Balancer origin     ########

resource "aws_cloudfront_distribution" "cloudfront_lb" {
  enabled         = true
  is_ipv6_enabled = true
  comment         = var.cloudfront_comment
  aliases         = var.cloudfront_aliases

  origin {
    domain_name = var.origin_dns_name
    origin_id   = var.origin_dns_name
    origin_path = var.origin_path

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = var.cloudfront_origin_protocol_policy
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  default_cache_behavior {
    target_origin_id       = var.origin_dns_name
    viewer_protocol_policy = "redirect-to-https"
    allowed_methods        = ["GET", "HEAD", "OPTIONS", "POST", "PUT", "PATCH", "DELETE"]
    cached_methods         = ["GET", "HEAD", "OPTIONS"]
    compress               = true

    # Forward all headers, query strings and cookies (disables caching effectively)
    forwarded_values {
      query_string = true

      cookies {
        forward = "all"
      }

      headers = ["*"]
    }

    min_ttl     = var.min_ttl
    default_ttl = var.default_ttl
    max_ttl     = var.max_ttl
  }

  price_class = "PriceClass_200"

  restrictions {
    geo_restriction {
      restriction_type = "none"
      locations        = []
    }
  }

  viewer_certificate {
    acm_certificate_arn      = var.acm_certificate_arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }


  tags = {
    Terraform = "True"
    Project   = var.project_name
  }

  wait_for_deployment = false

}

resource "aws_cloudfront_response_headers_policy" "backend_response_headers_policy" {
  count = var.enable_backend_response_headers ? 1 : 0
  name  = var.response_headers_policy_name

  security_headers_config {
    strict_transport_security {
      override                   = true
      access_control_max_age_sec = 31536000 // 1 year in seconds
      include_subdomains         = true
      preload                    = true
    }

    referrer_policy {
      override        = true
      referrer_policy = "no-referrer"
    }

    xss_protection {
      mode_block = true
      override   = true
      protection = true
    }

    content_type_options {
      override = true
    }

    frame_options {
      override     = true
      frame_option = "SAMEORIGIN"
    }
  }
}