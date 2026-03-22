output "arn" {
  value = aws_cloudfront_distribution.cloudfront_lb.arn
}

output "cloudfront_distribution_id" {
  description = "CloudFront distribution ID"
  value       = aws_cloudfront_distribution.cloudfront_lb.id
}