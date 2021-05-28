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
  
  Create a Service Principal for Terraform 
    Use below link for instructions:
  https://github.com/medum/Azure-Infrastructure-Operations/blob/main/README.md
  
  Selenium:
   Download chrome driver 
   https://sites.google.com/chromium.org/driver/
    pip install -U selenium
    sudo apt-get install -y chromium-browser
 Instructions to run the project
 teps
Clone this repo:
git clone https://github.com/medum/testingProject3.git
Open a Terminal in VS Code and connect to your Azure Account and get the Subscription ID
      az login 
      az account list --output table
      ![image](https://user-images.githubusercontent.com/49653011/119430206-5a60ff80-bcde-11eb-8aa8-80c85bfdb259.png)
      Configure storage account to Store Terraform state
          Execute the script azure-storage-account.sh :
          ./azure-storage-account.sh
          Take notes of storage_account_name, container_name, access_key . They are will be used in main.tf terrafrom files ( lines 15 to 19)
          storage_account_name: <accountName>: tstate access_key: <accessKey>

![packerImage](https://user-images.githubusercontent.com/49653011/119430393-b4fa5b80-bcde-11eb-9343-3cce9fe439bb.PNG)


  backend "azurerm" {
    storage_account_name = "<accountName>"
    container_name       = "<ContainerName>"
    key                  = "terraform.tfstate"
    access_key           = "<access key>"
Create a Service Principal with Contributor role, performing the following steps:
az ad sp create-for-rbac --name="<name>" --role="Contributor" 
Take notes of appId, password, and tenant as will be used at terraform.tfvars file (lines 2 to 5)

Create a Resource Group for your VM image using Packer and build the Image ( Ubuntu 18.04)
az group create -n RG-<imageName> -l eastus2
packer --version
cd packer
packer build ubuntu-image.json
![PackerImage2](https://user-images.githubusercontent.com/49653011/119430935-a6607400-bcdf-11eb-8708-4ce3ed5ecc0d.PNG)

Here you will get an Ubuntu 18.04 VM Image that will be used to create the VM.!!! Take note of the following values since you will need terraform.tfvars

![image](https://user-images.githubusercontent.com/49653011/119430860-7fa23d80-bcdf-11eb-8231-4413b280ad6d.png)

On your terminal create a SSH key and also perform a keyscan of your github to get the known hosts.
ssh-keygen -t rsa
cat ~/.ssh/id_rsa.pub
ssh-keyscan github.com
  ![sshKeys](https://user-images.githubusercontent.com/49653011/119430894-8e88f000-bcdf-11eb-9a4a-ad9578189538.PNG)

From the terminal, change into terraform directory
cd
cd terraform
7.1. Copy the terraform-example.tfvars as terraform.tfvars and fill the parameters marked as to fill as indicated with the values from steps 5, 6 and 7.

cp terraform-example.tfvars terraform.tfvars
nano terraform.tfvars
Complete the following parameters:

parameter	Link
subscription_id	subscription id
client_id	service principal client app id
client_secret	service principal password
tenant_id	service principal tenandt id
location	location
resource_group	Resource Group
application_type	Name of the APP - must be unique
virtual_network_name	Name of the VNet
packer_image	Packer Image ID created earlier
admin_username	admin username of the VM
public_key_path	path of the id_rsa.pub file
7.2. Don't forget also modify the main.tf as was pointed on step 3 !!!


Login to Azure DevOPs and perform the following settings before to execute the Pipeline.
8.1. Install these Extensions :

JMeter (https://marketplace.visualstudio.com/items?itemName=AlexandreGattiker.jmeter-tasks&targetId=625be685-7d04-4b91-8e92-0a3f91f6c3ac&utm_source=vstsproduct&utm_medium=ExtHubManageList)

PublishHTMLReports (https://marketplace.visualstudio.com/items?itemName=LakshayKaushik.PublishHTMLReports&targetId=625be685-7d04-4b91-8e92-0a3f91f6c3ac&utm_source=vstsproduct&utm_medium=ExtHubManageList)

Terraform (https://marketplace.visualstudio.com/items?itemName=ms-devlabs.custom-terraform-tasks&targetId=625be685-7d04-4b91-8e92-0a3f91f6c3ac&utm_source=vstsproduct&utm_medium=ExtHubManageList)

8.2 Create a Project into your Organization
  ![image](https://user-images.githubusercontent.com/49653011/119431011-cb54e700-bcdf-11eb-8de7-b18324522ac0.png)


8.3. Create the Service Connection in Project Settings > Pipelines > Service Connection
![image](https://user-images.githubusercontent.com/49653011/119431512-b9c00f00-bce0-11eb-9458-1f4b6e5a2bee.png)

be sure that you are verified and authenticated here!!! get the url to have the Service Connection ID: (https://dev.azure.com///_apis/serviceendpoint/endpoints?api-version=5.0-preview.2)

8.4. Add into Pipelines --> Library --> Secure files these 2 files: the private secure file : id_rsa key the terraform tfvars file : terraform.tfvars

![image](https://user-images.githubusercontent.com/49653011/119431716-0dcaf380-bce1-11eb-9bad-76cd4adebf41.png)


8.5. Create a Pipeline --> Environment named "WEBAPP-TEST" as is the one used in the pipeline.yaml. Copy the Registration script ( in Linux) since it must be executed on the created VM :
![image](https://user-images.githubusercontent.com/49653011/119431634-ed9b3480-bce0-11eb-820f-5e5bbba92aa9.png)

Something similar to

mkdir azagent;cd azagent;curl -fkSL -o vstsagent.tar.gz https://vstsagentpackage.azureedge.net/agent/2.183.1/vsts-agent-linux-x64-2.183.1.tar.gz;tar -zxvf vstsagent.tar.gz; if [ -x "$(command -v systemctl)" ]; then ./config.sh --environment --environmentname "VM-TEST" --acceptteeeula --agent $HOSTNAME .....
Enter the above script into the linux VM created on terraform by ssh and execute it, to get at the end a result like:

Successfully added the agent
Testing agent connection.
....
   Active: active (running) since Tue 2021-03-09 03:20:16 UTC; 13ms ago
 Main PID: 2330 (runsvc.sh)
    Tasks: 7 (limit: 4680)
   CGroup: /system.slice/vsts.agent.javiercaparo574..ci\x2dcd\x2dtest\x2dautomation.service
           ├─2330 /bin/bash /home/udacity/azagent/runsvc.sh
           └─2333 ./externals/node10/bin/node ./bin/AgentService.js
Modify the following lines on azure-pipelines.yaml before to update your own repo :
Line #	parameter	description
13	knownHostsEntry	the knownHost of your ssh-keyscan github
14	sshPublicKey	your public ssh key
66	azureSubscription	your Pipeline --> Service Connection ID ( step 10.3)
Update your repo to get the new azure-pipelines.yaml file updated

Create a New Pipeline in your Azure DevOPs Project
Located at GitHub
Select your Repository
Existing Azure Pipelines YAML file
Choosing azure-pipelines.yaml file
Wait the Pipeline is going to execute on the following Stages:
Build --> FirstWait --> WebApp Deployment --> UI Tests (selenium) -> Integration Tests (postman) --> JMeter -->secondWait

img2
![image](https://user-images.githubusercontent.com/49653011/119718526-ad999600-be35-11eb-8b51-48408198c948.png)

Explanation of the Stages
Provisioning IaC : using Terraform , perform the provisioning of the IaC (RG, VNet, subnet, public IP, App Service, VM Linux).

Build: Build FakeRestAPI artifact by archiving the entire fakerestapi directory into a zip file and publishing the pipeline artifact to the artifact staging directory , same for Selenium py file.

Wait: just wait 1minute in case you still did not run the Environment Agent registration script on the created VM ( so still have time to do it)

Deployments : Deploy FakeRestAPI artifact to the Azure App Service ( created on IaC). The deployed webapp URL is https://jc-test2-appservice.azurewebsites.net where jc-test2-appservice is the Azure App Service resource name in small letters. And also deploy Selenium and Chromium to the VM created in IaC

Integration Tests: Postman Regression and Data Validation tests (using newman/postman) to the APP api created above and publishing the results.

JMeter Tests: JMeter Tests - Endurance & Stress Tests to the APP created above, and publish the results
  Out Put looks like this:
![image](https://user-images.githubusercontent.com/49653011/119913466-f92e6b80-bf2b-11eb-8189-e3637b232bc3.png)
![image](https://user-images.githubusercontent.com/49653011/119913645-6e9a3c00-bf2c-11eb-89ea-dc020f0a022a.png)
![image](https://user-images.githubusercontent.com/49653011/119913851-faac6380-bf2c-11eb-9e0d-f31c3c88f040.png)
![image](https://user-images.githubusercontent.com/49653011/119914406-03516980-bf2e-11eb-9b08-064950c6bc75.png)
![image](https://user-images.githubusercontent.com/49653011/119914793-0ac54280-bf2f-11eb-8c66-7da6b6ec6714.png)
![image](https://user-images.githubusercontent.com/49653011/119921066-5c73ca00-bf3b-11eb-9550-bd7e0b6a7419.png)
![image](https://user-images.githubusercontent.com/49653011/119921281-b7a5bc80-bf3b-11eb-9433-e76c8bb9073b.png)
![image](https://user-images.githubusercontent.com/49653011/119921463-08b5b080-bf3c-11eb-8bb7-ed2cfdc2f705.png)
![image](https://user-images.githubusercontent.com/49653011/119921581-41ee2080-bf3c-11eb-9bfb-e3f3a3ec7388.png)
![image](https://user-images.githubusercontent.com/49653011/119921686-6ea23800-bf3c-11eb-9de7-ca465a13bc35.png)

  

UI Tests : Execution of the Selenium Tests an publish its results using the WEBAPP-TEST environment.

WaitforApproval: Manual Intervention to approve the Pipeline and resume it ( 2 hours as maximum)

DestroyIaC: Destroy the IaC using terraform destroy. Clean up the resources.

Create a Log Analytics workspace using this script for simplicity. It will be created on the same RG used by terraform (so if put another name, change the RG in the script!!)
./deploy_log_analytics_workspace.sh
Go the WORKSPACE ID & WORKSPACE PRIMARY KEY

Enter to the VM by ssh and install the OSMAgent.
wget https://raw.githubusercontent.com/Microsoft/OMS-Agent-for-Linux/master/installer/scripts/onboard_agent.sh && sh onboard_agent.sh -w <YOUR WORKSPACE ID> -s <YOUR WORKSPACE PRIMARY KEY>
sudo /opt/microsoft/omsagent/bin/service_control restart <YOUR WORKSPACE ID>
Set up email alerts in the App Service:
In the azure portal go to the app service > Alerts > New Alert Rule. Add an HTTP 404 condition and add a threshold value of 1. This will create an alert if there are two or more consecutive 404 alerts. Click Done. Then create an action group with notification type Email/SMS message/Push/Voice and choose the email option. Set the alert rule name and severity. Wait ten minutes for the alert to take effect. If you then visit the URL of the app service and try to go to a non-existent page more than once it should trigger the email alert.
  ![image](https://user-images.githubusercontent.com/49653011/119432782-f4c34200-bce2-11eb-81d4-35cdfdffc33a.png)
![image](https://user-images.githubusercontent.com/49653011/119433637-9f883000-bce4-11eb-882d-787c6d2ba35e.png)
![image](https://user-images.githubusercontent.com/49653011/119720763-61038a00-be38-11eb-89cc-97bca02b277d.png)
![image](https://user-images.githubusercontent.com/49653011/119721122-c6577b00-be38-11eb-92e5-506adb951032.png)
![image](https://user-images.githubusercontent.com/49653011/119721476-3108b680-be39-11eb-9686-b5e78635e10b.png)
![image](https://user-images.githubusercontent.com/49653011/119723242-3cf57800-be3b-11eb-9574-3921864bd120.png)
![image](https://user-images.githubusercontent.com/49653011/119723369-5bf40a00-be3b-11eb-80da-793a1f1a1af6.png)
![image](https://user-images.githubusercontent.com/49653011/119729943-3408a480-be43-11eb-8766-1958e72b9f74.png)
![image](https://user-images.githubusercontent.com/49653011/119730168-6914f700-be43-11eb-93f0-9b81eb92f04a.png)


Go to the App service > Diagnostic Settings > + Add Diagnostic Setting. Tick AppServiceHTTPLogs and Send to Log Analytics Workspace created on step above and Save.

Go back to the App service > App Service Logs . Turn on Detailed Error Messages and Failed Request Tracing > Save. Restart the app service.

Set up log analytics workspace properly to get logs:
Go to Virtual Machines and Connect the VM created on Terraform to the Workspace ( Connect). Just wait that shows Connected.

Set up custom logging , in the log analytics workspace go to Advanced Settings > Data > Custom Logs > Add + > Choose File. Select the file selenium.log > Next > Next. Put in the following paths as type Linux:

/var/log/selenium/selenium.log

Give it a name ( selenium_logs_CL) and click Done. Tick the box Apply below configuration to my linux machines.

Go to the App Service web page and navigate on the links and also generate 404 not found , example:
https://jc-test2-appservice.azurewebsites.net

https://jc-test2-appservice.azurewebsites.net/feeeee  ( click this many times so alert will be raised too)
Go to Log Analytics Workspace , to run the following queries:

Operation
| where TimeGenerated > ago(2h)
| summarize count() by TimeGenerated, OperationStatus, Detail
AppServiceHTTPLogs
| where TimeGenerated < ago(2h)
  and ScStatus == '404'
SELENIUM_LOGS_CL
After some minutes ( 3 to 10 minutes) , check the email configured since an alert message will be received. and also check the Log Analytics Logs , so you can get visualize the logs and analyze with more detail.
![image](https://user-images.githubusercontent.com/49653011/119434903-20e0c200-bce7-11eb-8b26-a8cd6f714057.png)


Clean it Up
on Az DevOps Pipeline , give approval on the notification to resume with the Destroy Terraform Stage.

and finally run this script to delete the PackerImage and tstate StorageAccount Resources groups.

./clean-up-rgs.sh
Useful Links
Collect custom logs with Log Analytics agent in Azure Monitor ( https://docs.microsoft.com/en-us/azure/azure-monitor/agents/data-sources-custom-logs)

Collect data from an Azure virtual machine with Azure Monitor (https://docs.microsoft.com/en-us/azure/azure-monitor/vm/quick-collect-azurevm)

Environment - virtual machine resource (https://docs.microsoft.com/en-us/azure/devops/pipelines/process/environments-virtual-machines?view=azure-devops)

Build GitHub repositories (https://docs.microsoft.com/en-us/azure/devops/pipelines/repos/github?view=azure-devops&tabs=yaml)

Tutorial: Store Terraform state in Azure Storage (https://docs.microsoft.com/en-us/azure/developer/terraform/store-state-in-azure-storage)

Create your first pipeline (https://docs.microsoft.com/en-us/azure/devops/pipelines/create-first-pipeline?view=azure-devops&tabs=azure-cli%2Ctfs-2018-2%2Cbrowser)

Create a project in Azure DevOps (https://docs.microsoft.com/en-us/azure/devops/organizations/projects/create-project?view=azure-devops&tabs=preview-page)

Create a Linux VM with infrastructure in Azure using Terraform (https://docs.microsoft.com/en-us/azure/developer/terraform/create-linux-virtual-machine-with-infrastructure)

Create a Log Analytics workspace with Azure CLI 2.0 (https://docs.microsoft.com/en-us/azure/azure-monitor/logs/quick-create-workspace-cli)

Hashicorp Terraform with Azure (https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet)

azure-pipelines-jmeter-extension (https://marketplace.visualstudio.com/items?itemName=AlexandreGattiker.jmeter-tasks&ssr=false#qna) (https://github.com/algattik/azure-pipelines-jmeter-extension/issues?utm_source=vsmp&utm_medium=ms%20web&utm_campaign=mpdetails)

How to troubleshoot issues with the Log Analytics agent for Linux (https://docs.microsoft.com/en-us/azure/azure-monitor/agents/agent-linux-troubleshoot)

Future Improvements
Use VMSS in Terraform
Use Microservises
                               

  
