# pre_k8s_node
pre provisioning for kubespray on debian9(stretch)

### example
ansible-playbook -b -i inventory --private-key=/path/to/private_key --limit="all" pre_k8s_node.yml
