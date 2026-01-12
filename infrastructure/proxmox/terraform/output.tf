output "ansible_inventory" {
  description = "Ansible inventory format"
  value = <<-EOT
[master]
${join("\n", [for name, config in local.k3s_vms : "${name} ansible_host=${config.ip}" if can(regex("master", name))])}

[workers]
${join("\n", [for name, config in local.k3s_vms : "${name} ansible_host=${config.ip}" if can(regex("worker", name))])}
EOT
}
