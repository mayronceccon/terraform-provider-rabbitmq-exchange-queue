# Terraform - Rabbitmq Exchange and Queue

Módulo do terraform para criação de exchanges e filas no Rabbitmq de uma forma simplificada.

## Requirements

- [cyrilgdn/rabbitmq](https://registry.terraform.io/providers/cyrilgdn/rabbitmq/latest/docs)

## Usage

### Exchanges

#### DLX

Para configurar um exchange como DLX (Dead Letter Exchange), o paramêtro `is_dlx` deve ser `true`

```
module "exchange_dead_letter_exchange" {
  source = "github.com/mayronceccon/terraform-provider-rabbitmq-exchange-queue//exchanges"
  is_dlx = true
  name   = "dead_letter_exchange"
}
```

#### Normal

```
module "exchange_any_exchange" {
  source = "github.com/mayronceccon/terraform-provider-rabbitmq-exchange-queue//exchanges"
  name   = "exchange_any_exchange"
}
```

### Queues

#### DLQ

```
module "queue__dlq" {
  source      = "github.com/mayronceccon/terraform-provider-rabbitmq-exchange-queue//queues"
  is_dlq      = true
  vhost       = rabbitmq_vhost.cadastro_vhost.name
  name        = "registration_form__created__dlq"
  exchange    = module.exchange_dead_letter_exchange.name
  routing_key = module.queue_registration_form__created.name
}
```

#### Normal

```
module "queue_registration_created" {
  source   = "github.com/mayronceccon/terraform-provider-rabbitmq-exchange-queue//queues"
  name     = "queue_registration_created"
  exchange = module.exchange_any_exchange.name
}
```
