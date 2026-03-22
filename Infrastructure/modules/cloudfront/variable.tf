variable "project_name" {
  description = "Project Name -> Name to be used on all the resources as identifier"
  type        = string
  default     = ""
}
variable "cloudfront_comment" {
  type    = string
  default = "null"
}
variable "origin_dns_name" {
  type    = string
  default = "null"
}
variable "cloudfront_aliases" {
  description = "List of domain names (aliases) for the CloudFront distribution"
  type        = list(string)
  default     = []
}
variable "acm_certificate_arn" {
  type    = string
  default = "null"
}
variable "cloudfront_origin_protocol_policy" {
  type    = string
  default = "null"
}
variable "min_ttl" {
  type = number
}
variable "max_ttl" {
  type = number
}
variable "default_ttl" {
  type = number
}
variable "origin_path" {
  type    = string
  default = ""
}
variable "enable_backend_response_headers" {
  type    = bool
  default = false
}
variable "response_headers_policy_name" {
  type    = string
  default = null
}