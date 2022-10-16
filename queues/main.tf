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

variable "exchange" {
  type = string
}

variable "is_dlq" {
  type    = bool
  default = false
}

variable "routing_key" {
  type    = string
  default = ""
}

resource "rabbitmq_queue" "my_queue" {
  vhost = var.vhost
  name  = var.name

  settings {
    durable     = var.durable
    auto_delete = var.auto_delete
    arguments = {
      "x-queue-type"              = "classic"
      "x-dead-letter-routing-key" = var.is_dlq ? "${var.name}" : null
      "x-dead-letter-exchange"    = var.is_dlq ? "${var.exchange}" : null
    }
  }
}

resource "rabbitmq_binding" "my_binding_queue" {
  lifecycle {
    precondition {
      condition     = !(var.is_dlq == true && length(var.routing_key) == 0)
      error_message = "Variable \"routing_key\" is required for dlq"
    }
  }

  vhost            = var.vhost
  destination_type = "queue"
  source           = var.exchange
  destination      = rabbitmq_queue.my_queue.name
  routing_key      = var.is_dlq ? var.routing_key : null
}

output "name" {
  value     = var.name
  sensitive = false
}
