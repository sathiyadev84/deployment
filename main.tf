terraform {
  required_providers {
    zedcloud = {
      source  = "zededa/zedcloud"
      version = "2.3.0-RC"
    }
    rancher2 = {
        source  = "rancher/rancher2"
        version = "6.0.0"
    }
  }
}

provider "zedcloud" {
    zedcloud_url   = var.zededa_controller_url
    zedcloud_token = var.zededa_token
}

provider "rancher2" {
    api_url    = var.rancher_server_url
    access_key = var.rancher2_access_key
    secret_key = var.rancher2_secret_key
    insecure   = true
}

