terraform {
  required_providers {
    ovh = { source  = "ovh/ovh" }
    openstack = { source  = "terraform-provider-openstack/openstack" }
  }
}

provider "ovh" {
}

data "ovh_order_cart" "this" {
  ovh_subsidiary = "fr"
  description    = "Public Cloud Project"
}

data "ovh_order_cart_product_plan" "this" {
  cart_id        = data.ovh_order_cart.this.id
  price_capacity = "renew"
  product        = "cloud"
  plan_code      = "project.2018"
}

resource "ovh_cloud_project" "this" {
  ovh_subsidiary = data.ovh_order_cart.this.ovh_subsidiary
  description    = "helloworld"
  payment_mean   = null # not required anymore

  plan {
    duration     = data.ovh_order_cart_product_plan.this.selected_price.0.duration
    plan_code    = data.ovh_order_cart_product_plan.this.plan_code
    pricing_mode = data.ovh_order_cart_product_plan.this.selected_price.0.pricing_mode
  }
}
