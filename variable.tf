variable "zededa_controller_url" {
    description = "zededa cloud URL"
    default     = "https://zedcontrol.gmwtus.zededa.net"
    type        = string
}

variable "zededa_token" {
    description =  "Zededa cloud access token"
    default     = "Qls7fcNv6i9w937ZWGY1QxCZzYLTmfD7WcNAvTJYexJ4kty1uZN2e6mNNc03VlhU5Tr9o0SxIodFnZ3wzdSc0f-227wo0b0_0PyfQP7LVHx0pRxzcBFwoNNgNb2yegSKf6XCDqzP5ioDfj0tyVDRgoTIuyJsOtl_jjvLi9VLEtA="
    type        = string
}

variable "rancher_server_url" {
    description = "rancher multi cluster manager URL"
    default     = "https://20.55.38.154"
    type        = string
}

variable "rancher2_access_key" {
    description = "rancher server access key"
    default     = "token-klxpg"
    type        = string
}

variable "rancher2_secret_key" {
    description = "rancher server secret key/token"
    default     = "9dnrrb62drnjgmkhx72c96cpbk48xwv68kkj98gcsfx7vzf7bqh8gw"
    type        = string
}

variable "cluster_name" {
    description = "cluster name"
    default     = "cluster-tf01"
    type        = string
}

variable "rancher_edge_app" {
    description = "zededa edge app from marketplace"
    default     = "k3s_runtime_gpu_enabled"
    type        = string
}

variable "edge_node" {
  description = "Edge node name"
  default     = "HPE-Demo-device"
  type        = string
}

variable "project_name" {
    description = "project name"
    default     =  "Mid-server"
    type        = string
}

variable "rancher2_project_name" {
    description = "rancher2 project name"
    default     = "Default"
    type        = string
  
}