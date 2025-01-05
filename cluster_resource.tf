
resource "rancher2_cluster" "cluster_create" {
    name = var.cluster_name
    description = "cluster instance name"
}

//resource "rancher2_project" "zededa_rancher_project" {
//  name = var.rancher2_project
//  cluster_id = rancher2_cluster.cluster_create.id
//}

data "rancher2_project" "all_projects" {
    name = var.rancher2_project_name
    cluster_id = rancher2_cluster.cluster_create.id
}

resource "null_resource" "wait_for_cluster_active" {
    provisioner "local-exec" {
        command = <<EOT
        while true; do
            STATUS=$(curl -s -k -H "Authorization: Bearer ${var.rancher2_access_key}:${var.rancher2_secret_key}" \
            "${var.rancher_server_url}/v3/clusters/${rancher2_cluster.cluster_create.id}" | jq -r '.state')
            echo "Cluster status: $STATUS"
            if [ "$STATUS" == "active" ]; then
                echo "Cluster is active!"
                break
            fi
            echo "Waiting for cluster to become active..."
            sleep 30
        done
        EOT
    }
    depends_on = [rancher2_cluster.cluster_create]
}

resource "rancher2_catalog_v2" "hardhat" {
    depends_on = [null_resource.wait_for_cluster_active]
    cluster_id = rancher2_cluster.cluster_create.id
    name = "hardhat-detection"
    url = "https://sathiyadev84.github.io/edgeai/charts"
}

resource "rancher2_app_v2" "my_hardhat" {
    depends_on = [null_resource.wait_for_cluster_active, rancher2_catalog_v2.hardhat]
    cluster_id = rancher2_cluster.cluster_create.id
    name = "hardhat"
    namespace = "default"
    repo_name = "hardhat-detection"
    chart_name = "my-hardhat"
}