resource "aws_wafv2_ip_set" "main" {
  count = var.use_public_endpoint ? 1 : 0

  name               = format("%s-waf-allowed-ips", local.stack_identifier)
  description        = "Allowed IPs for Device-Insights API"
  scope              = "REGIONAL"
  ip_address_version = "IPV4"
  addresses          = var.allowed_ips

  tags = merge(
    local.common_tags,
    {
      Name : format("%s-waf-allowed-ips", local.stack_identifier)
    }
  )
}