### Pre-requisite:

- Ansible requires vm or physical server with linux operating system as control node
- Ansible uses WinRM to connect windows instance so we need pywinrm package installed on control node.

### Setup/install following packages on Control Node

sudo yum install ansible

curl -O https://bootstrap.pypa.io/get-pip.py

python get-pip.py --user

sudo pip install pywinrm

sudo pip install boto

### Requirement: 

Ansible script to validate application health after deployment (Web and SQL)

### Implementation

- Used dynamic inventory to retrieve instances by tags
- Playbook will deploy dontet core application to filter hosts via dynamic inventory
- Will perform application healtcheck to specific endpoint after deployment.
