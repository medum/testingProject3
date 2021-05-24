# Ensuring Quality Releases
![image](https://user-images.githubusercontent.com/49653011/119281205-cec67080-bc02-11eb-8035-e2ad5dbec7e7.png)
Project Tools and Environment
  Azure DevOps
  Selenium
  Terraform
  JMeter
  Postman
Dependencies
  Terraform
  JMeter
  Postman
  Python
  Selenium
Installation & Configuration:
Terraform in Azure
  to Configure the storage accound and state backend following data is needed:
    storage_account_name: The name of the Azure Storage account.
    container_name: The name of the blob container.
    key: The name of the state store file to be created.
    access_key: The storage access key.
  ![image](https://user-images.githubusercontent.com/49653011/119281459-d33f5900-bc03-11eb-9325-1c25a28bdad5.png)
  
  Create a Service Principal for Terraform :
    Use below link for instructions:
  https://github.com/medum/Azure-Infrastructure-Operations/blob/main/README.md
  
  Selenium:
   Download chrome driver 
   https://sites.google.com/chromium.org/driver/
    pip install -U selenium
    sudo apt-get install -y chromium-browser
