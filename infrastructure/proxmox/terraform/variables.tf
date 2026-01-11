variable "proxmox_api_url" {
  description = "Proxmox API URL"
  type        = string
}

variable "proxmox_token_id" {
  description = "Proxmox API Token ID (e.g terraform-prov@pve!mytoken) "
  type        = string
}

variable "proxmox_token_secret" {
  description = "Proxmox API key (e.g afcd8f45-acc1-4d0f-bb12-a70b0777ec11)"
  type        = string
}

variable "proxmox_node" {
  description = "Proxmox node name"
  type        = string
}

variable "template_name" {
  description = "VM template name"
  type        = string
}

variable "storage_name" {
  description = "Storage pool name"
  type        = string
}

variable "ssh_public_key" {
  description = "SSH public key for VM access"
  type        = string
}
