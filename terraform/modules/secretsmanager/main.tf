# Secrets Manager Secrets
resource "aws_secretsmanager_secret" "main" {
  for_each = var.secrets

  name                    = "${var.project_name}-${var.environment}-${each.key}"
  description             = each.value.description
  recovery_window_in_days = var.recovery_window_in_days

  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-${var.environment}-${each.key}"
    }
  )
}

# Secret Versions
resource "aws_secretsmanager_secret_version" "main" {
  for_each = var.secrets

  secret_id     = aws_secretsmanager_secret.main[each.key].id
  secret_string = jsonencode(each.value.secret_data)
}