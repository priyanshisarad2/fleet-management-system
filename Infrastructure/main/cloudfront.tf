module "cloudfront-distribution-fleetman-webapp" {
  count                             = var.create_cloudfront_fleetman_webapp ? 1 : 0
  source                            = "../modules/cloudfront"
  project_name                      = var.project_name
  cloudfront_comment                = "${var.project_name} webapp cloudfront distribution"
  cloudfront_aliases                = [var.fleetman_webapp_domain]
  acm_certificate_arn               = var.acm_certificate_arn
  origin_dns_name                   = var.fleetman_webapp_alb_origin_domain
  cloudfront_origin_protocol_policy = "https-only"
  min_ttl                           = 0
  default_ttl                       = 3600
  max_ttl                           = 86400
  enable_backend_response_headers   = true
  response_headers_policy_name      = "${var.project_name}-webapp-response-headers-policy"
}