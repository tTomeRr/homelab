.PHONY: help infra-init infra-plan infra-apply infra-destroy infra-output \
        ansible-deps ansible-init ansible-firewall ansible-k3s ansible-all \
        inventory clean

TERRAFORM_DIR := infrastructure/proxmox/terraform
ANSIBLE_DIR := infrastructure/ansible

help:
	@echo "Homelab Management"
	@echo ""
	@echo "Infrastructure (Terraform):"
	@echo "  infra-init      Initialize Terraform"
	@echo "  infra-plan      Preview infrastructure changes"
	@echo "  infra-apply     Apply infrastructure changes"
	@echo "  infra-destroy   Destroy all infrastructure"
	@echo "  infra-output    Show Terraform outputs"
	@echo ""
	@echo "Configuration (Ansible):"
	@echo "  ansible-deps    Install Ansible dependencies"
	@echo "  ansible-init    Run system initialization on all VMs"
	@echo "  ansible-firewall Configure firewall rules"
	@echo "  ansible-k3s     Deploy K3s cluster"
	@echo "  ansible-all     Run full Ansible playbook"
	@echo ""
	@echo "Utilities:"
	@echo "  inventory       Generate Ansible inventory from Terraform"
	@echo "  clean           Remove generated files"

# Terraform targets
infra-init:
	cd $(TERRAFORM_DIR) && terraform init

infra-plan:
	cd $(TERRAFORM_DIR) && terraform plan

infra-apply:
	cd $(TERRAFORM_DIR) && terraform apply

infra-destroy:
	cd $(TERRAFORM_DIR) && terraform destroy

infra-output:
	cd $(TERRAFORM_DIR) && terraform output

# Ansible targets
ansible-deps:
	cd $(ANSIBLE_DIR) && ansible-galaxy install -r requirements.yml

ansible-init:
	cd $(ANSIBLE_DIR) && ansible-playbook main.yaml --tags init

ansible-firewall:
	cd $(ANSIBLE_DIR) && ansible-playbook main.yaml --tags security

ansible-k3s:
	cd $(ANSIBLE_DIR) && ansible-playbook main.yaml --tags k3s

ansible-all:
	cd $(ANSIBLE_DIR) && ansible-playbook main.yaml

# Utility targets
inventory:
	cd $(TERRAFORM_DIR) && terraform output -raw ansible_inventory > ../../ansible/inventory.ini

clean:
	rm -f $(ANSIBLE_DIR)/inventory.ini
