# Network Firewall Rule Group
resource "aws_networkfirewall_rule_group" "AmazonDomainRuleGroup" {
  capacity    = 10
  description = "Allow Access to AWS services"
  name        = "AllowAmazonDomains"
  type        = "STATEFUL"
  rule_group {
    stateful_rule_options {
      rule_order = "STRICT_ORDER"
    }
    rules_source {
      rules_source_list {
        generated_rules_type = "ALLOWLIST"
        target_types         = ["TLS_SNI", "HTTP_HOST"]
        targets              = [".amazon.com", ".amazonaws.com"]
      }
    }
  }
}

resource "aws_networkfirewall_rule_group" "HttpPortRuleGroup" {
  capacity    = 10
  description = "Allow Access to EC2 instance on port 80"
  name        = "AllowPort80"
  type        = "STATEFUL"
  rule_group {
    stateful_rule_options {
      rule_order = "STRICT_ORDER"
    }
    rules_source {
      stateful_rule {
        action = "PASS"
        header {
          destination      = aws_subnet.Inspection_VPC_Protected_Workload_Subnet.cidr_block
          destination_port = 80
          protocol         = "HTTP"
          direction        = "FORWARD"
          source           = "ANY"
          source_port      = "ANY"
        }
        rule_option {
          keyword = "sid"
          settings = ["11111"]
        }
      }
    }
  }
}

# Network Firewall Policy
resource "aws_networkfirewall_firewall_policy" "FirewallPolicy" {
  name = "ANFW-Lab-Policy"

  firewall_policy {
    stateful_rule_group_reference {
      priority     = 1
      resource_arn = aws_networkfirewall_rule_group.AmazonDomainRuleGroup.arn
    }
    stateful_rule_group_reference {
      priority     = 2
      resource_arn = aws_networkfirewall_rule_group.HttpPortRuleGroup.arn
    }
    stateless_default_actions          = ["aws:forward_to_sfe"]
    stateless_fragment_default_actions = ["aws:forward_to_sfe"]
    stateful_default_actions           = ["aws:drop_established"]
    stateful_engine_options {
      rule_order = "STRICT_ORDER"
    }
  }

  depends_on = [
    aws_networkfirewall_rule_group.AmazonDomainRuleGroup,
    aws_networkfirewall_rule_group.HttpPortRuleGroup,
  ]
}
