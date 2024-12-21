variable "environment" {
  description = "The environment to deploy (staging or production)"
  type        = string
}

variable "cluster_ip" {
  description = "The ip of the cluster load balancer"
  type        = string
}

variable "kumpel_cloud_zone_id" {
  description = "The zone id of kumpel.cloud"
  type        = string
  default     = ""
}

variable "hcloud_token" {
  description = "Hetzner Cloud API token"
  type        = string
}

variable "ssh_access_ips" {
  description = "Static IP access to nodes"
  type        = list(string)
  default     = []
}

variable "location" {
  description = "Location for the servers"
  type        = string
  default     = "nbg1"
}

variable "ssh_keys" {
  description = "List of SSH key names to be used"
  type        = list(string)
}

variable "master_count" {
  description = "Number of master nodes"
  type        = number
}

variable "worker_count" {
  description = "Number of worker nodes"
  type        = number
}

variable "master_server_type" {
  description = "Type of server for master nodes"
  type        = string
}

variable "worker_server_type" {
  description = "Type of server for worker nodes"
  type        = string
}
