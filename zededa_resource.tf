data "zedcloud_edgenode" "edge_node" {
    name     = var.edge_node
    model_id = "f12ec705-1f85-4581-93a9-b0e3b6798b94"
    title    = var.edge_node
}

data "zedcloud_project" "project_name" {
    name = var.project_name
    type = "TAG_TYPE_PROJECT"
    title = var.project_name
}

data "zedcloud_application" "rancher_edge_app" {
    name  = var.rancher_edge_app
    title = var.rancher_edge_app
}

resource "zedcloud_network_instance" "app_switch_inf" {
    name      = "inf-eth0-${var.edge_node}"
    title     = "inf-eth0-${var.edge_node}"
    kind      = "NETWORK_INSTANCE_KIND_SWITCH"
    type      = "NETWORK_INSTANCE_DHCP_TYPE_UNSPECIFIED"
    port      = "eth0"
    device_id = data.zedcloud_edgenode.edge_node.id
}

resource "zedcloud_application_instance" "k3s_runtime_gpu" {
    name            = "k3s_runtime_gpu"
    activate        = true
    app_id          = data.zedcloud_application.rancher_edge_app.id
    project_id      = data.zedcloud_project.project_name.id
    device_id       = data.zedcloud_edgenode.edge_node.id
    app_type        = "APP_TYPE_VM"
    title           = "k3s_runtime_gpu"
    description     = "k3s_runtime_gpu"
    depends_on      = [rancher2_cluster.cluster_create, zedcloud_network_instance.app_switch_inf]
    interfaces {
        intfname    = "eth0"
        netinstname = zedcloud_network_instance.app_switch_inf.name
        privateip   = false
    }
    interfaces {
        intfname    =  "GPU"
        directattach = true
        netinstname = ""
        privateip = false
        io {
            name = "GPU"
            type = "IO_TYPE_OTHER"
        }
    }
    drives {
      imagename = "k3s_gpu_runtime_v4"
      drvtype   = "HDD"
      maxsize   = "104857600"
      preserve  = false
      target    = "Disk"
      readonly  = false
    }
    custom_config {
        name            =  "custom_config"
        add             = "true"
        override        = "false"
        field_delimiter = "###"
        template        = "I2Nsb3VkLWNvbmZpZwpydW5jbWQ6CiAtIGhvc3RuYW1lY3RsIHNldC1ob3N0bmFtZSAkenJpLnN5c3RlbS5lZGdlLWluc3RhbmNlLm5hbWUKIC0gYXB0IHVwZGF0ZSAteQogLSBhcHQtZ2V0IGluc3RhbGwgY29udGFpbmVyZCAteQogLSBzeXN0ZW1jdGwgZW5hYmxlIGNvbnRhaW5lcmQKIC0gYXB0IHVwZGF0ZSAteQogLSBjZCAvaG9tZS9wb2N1c2VyCiAtIGN1cmwgLXNmTCBodHRwczovL2dldC5rM3MuaW8gfCBJTlNUQUxMX0szU19WRVJTSU9OPSMjI0szU19WRVJTSU9OIyMjIElOU1RBTExfSzNTX0VYRUM9IyMjSU5TVEFMTF9LM1NfRVhFQyMjIyBLM1NfVE9LRU49IyMjSzNTX0NMVVNURVJfVE9LRU4jIyMgIEszU19VUkw9IyMjSzNTX1NFUlZFUl9VUkxfUE9SVCMjIyBzaCAtCiAtIHNsZWVwIDMwCiAtIGJhc2ggaW5zdGFsbC16ZWRlZGEtbnZpZGlhLXN0YWNrX3YzLnNoCiAtIHNsZWVwIDMwCiAtIHN1ZG8gcHl0aG9uMyBub2RlLWNvbmZpZ3VyZS5weQogLSBzbGVlcCAzMAogLSBzdWRvIHB5dGhvbjMgYXR0YWNoX2NsdXN0ZXIucHkgIyMjUkFOQ0hFUl9ZQU1MX1VSTCMjIwogLSBzdWRvIHJlYm9vdApmaW5hbF9tZXNzYWdlOiAiazNzICMjI1JPTEUjIyMgaGFzIGJlZW4gc2V0dXAsIGFmdGVyICRVUFRJTUUgc2Vjb25kcyI="
        variable_groups {
          name     = "k3s Cluster Parameters"
          required = true
          variables {
            type     = ""
            name     = "K3S_CLUSTER_TOKEN"
            label    = "K3S_CLUSTER_TOKEN"
            required = "true"
            default  = "\"\""
            value    = ""
            format   = "VARIABLE_FORMAT_TEXT"
            encode   = "FILE_ENCODING_UNSPECIFIED"
          }
          variables {
            name     = "ROLE"
            type     = ""
            label    = "Role of this node in the cluster"
            required = true
            value    = "Server"
            format   = "VARIABLE_FORMAT_DROPDOWN"
            encode   = "FILE_ENCODING_UNSPECIFIED"
            options {
                label = "Server"
                value = "Server"
            }
            options {
                label = "Agent"
                value = "Agent"
            }
          }
          variables {
            name     = "K3S_VERSION"
            required = true
            label    = "K3S_VERSION"
            format   = "VARIABLE_FORMAT_TEXT"
            value    = "v1.31.2+k3s1"
            encode   = "FILE_ENCODING_UNSPECIFIED"
          }
        }
        variable_groups {
            name     = "Server Node parameters"
            required = false
            condition {
                name     = "ROLE"
                value    =  "Server"
                operator = "CONDITION_OPERATOR_EQUALTO"
            }
            variables {
              name     = "RANCHER_YAML_URL"
              label    = "call home url"
              required = true
              format   = "VARIABLE_FORMAT_TEXT"
              encode   = "FILE_ENCODING_UNSPECIFIED"
              value    = rancher2_cluster.cluster_create.cluster_registration_token[0].manifest_url
            }
            variables {
              name     = "INSTALL_K3S_EXEC"
              label    = "INSTALL_K3S_EXEC"
              required = true
              format   = "VARIABLE_FORMAT_TEXT"
              value    = ""
              encode   = "FILE_ENCODING_UNSPECIFIED"
            }
        }
    }
}