output "ansible_inventory" {
  description = "Ansible inventory format"
  value = <<-EOT
[k3s_cluster:children]
server
agent

[server]
${join("\n", [for name, config in local.k3s_vms : "${name} ansible_host=${config.ip}" if can(regex("master", name))])}

[agent]
${join("\n", [for name, config in local.k3s_vms : "${name} ansible_host=${config.ip}" if can(regex("worker", name))])}

[k3s_cluster:vars]
ansible_port=22
ansible_user=ubuntu
k3s_version=v1.31.12+k3s1
token=changeme!
api_endpoint={{ hostvars[groups['server'][0]]['ansible_host'] | default(groups['server'][0]) }}
EOT
}
