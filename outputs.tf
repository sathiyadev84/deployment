output "manifest_url" {
  value = rancher2_cluster.cluster_create.cluster_registration_token[0].manifest_url
}

output "cluster_id" {
  value = rancher2_cluster.cluster_create.id
}
