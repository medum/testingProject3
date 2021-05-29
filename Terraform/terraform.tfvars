# Azure subscription vars
subscription_id = "d869cbf8-8990-4e0b-94ca-9ec4e5ee2463"
client_id       = "2e4a533b-0e77-45f3-a33b-bcde627341f6"
client_secret   = "1lShOuES7iGdYW-~ykF~D.tT7YeYATmvoK"
tenant_id       = "19cf5455-841e-4591-9654-f8b08846a572"

# Resource Group/Location
location         = "eastus2"
resource_group   = "proj3-packerIMG"
application_type = "AppService"

# Network
virtual_network_name = "project3-vm"

address_prefix_test  = "10.0.0.4"

# VM
packer_image   = "myPackerImage"
admin_username = "admin"

# public key in azure pipelines
public_key_path = "/home/vsts/work/_temp/id_rsa"

# public key on Windows local machine
# public_key_path = "~/.ssh/id_rsa.pub"
