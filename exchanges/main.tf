terraform {
  required_providers {
    rabbitmq = {
      source  = "cyrilgdn/rabbitmq"
      version = "1.5.1"
    }
  }
}

variable "vhost" {
  default = "/"
  type    = string
}

variable "name" {
  type = string
}

variable "durable" {
  type    = bool
  default = true
}

variable "auto_delete" {
  type    = bool
  default = false
}

variable "is_dlx" {
  type    = bool
  default = false
}

variable "exchange_type" {
  type    = string
  default = "fanout"

  validation {
    condition     = contains(["fanout", "direct", "topic"], var.exchange_type)
    error_message = "Allowed values for input_parameter are \"fanout\", \"direct\", or \"topic\"."
  }
}

resource "rabbitmq_exchange" "my_exchange" {
  vhost = var.vhost
  name  = var.name

  settings {
    type        = var.is_dlx ? "direct" : var.exchange_type
    durable     = var.durable
    auto_delete = var.auto_delete
  }
}

output "name" {
  value     = var.name
  sensitive = false
}
