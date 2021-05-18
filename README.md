# From Chef-Workstation
   -- go to "chef-repo/cookbooks"
   -- chef generate cookbook name_cookbook
   -- This will generate a directory named name_cookbook with some sub-folders and files
   -- Navigate to cookbooks/first_cookbook/
 
 # 2_Tomcat

Chef Cookbooks to Manage your CentOS / RHEL Infrastructure

# In this cookbook we will setup a 
1. Chef server
2. Chef Dev Kit
3. Chef Client

create cookbook to install and configure an Apache web server.

- cd ~/chef-repo/cookbooks/
- - - Create the cookbook called “2_Tomcat“. 
- - - chef generate cookbook 2_Tomcat

# Make sure you have user login details for Openstack Platform9 in vault
json = vaultGetSecrets()
        env.P9_USER=json.P9_USER
        env.P9_PWD=json.P9_PW
# Replace chef-server details
   -- Chef-Server user and .pem details for user_pipeline as this is required for the cookbook to work

# KEY_NAME = 'cloud-key'
      KITCHEN_KEY = '/root/.ssh/id_rsa'
      http_proxy = 'ADD YOUR PROXY-SERVER:8080'
      https_proxy = 'ADD YOUR PROXY-SERVER:8080'

# Upload the Cookbook

- [amousa@Replace With Your Chef-Workstation FQDN cookbooks]$ knife cookbook upload 2_Tomcat
- Uploading 2_Tomcat      [0.1.0]
- Uploaded 1 cookbook.
- [amousa@Replace With Your Chef-Workstation FQDN cookbooks]$ knife node run_list add Chef-Node Client FQDN for Testing httpd

# Jenkinsfile
 -- If you wont to use Jenkins-pipeline execute any of the .kitchen.yml files make sure user-details Available from vault 

# Output 

- Chef-Node Client FQDN for Testing:
 -  run_list:
 -  recipe[2_Tomcat]
 -  recipe[2_Tomcat_baseline]
 -  recipe[httpd]
-   [amousa@Replace With Your Chef-Workstation FQDN cookbooks]$

# Verification:

- knife --version
- knife client list

# Testing:

- Compile the files using Ruby 2.4, output below 
- 6 files inspected, no offenses detected

Retrieving the Configuration:

- Run the chef-client command on the client node to check with Chef server for any new run_list and run those run_list that has been assigned to it.

- chef-client
    - You can verify that this works by visiting your node’s IP address or domain name over a web browser.

    "http://	REPLACE IT WITH YOUR TEST LOCAL IP ADDRESS/" 

# Openstack .kitchen.yml setting required: rename .kitchen.yml-p9 to .kitchen.yml
  - openstack_username: 
  - openstack_api_key: 
  - openstack_auth_url: 'https://openstack-int.platform9.net/keystone/v3'
  
  - floating_ip_pool: 'Add Your-ExtNet'
  - openstack_region: 
  - openstack_region_name: 
  - openstack_project_name: 'ChefKitchen'
  - openstack_project_domain_id: default
  - openstack_user_domain_id: default
  - openstack_network_name: 'chef-internal'
  - key_name: <%= ENV['KEY_NAME'] %>
  - network_id: 'Add your network_id provided by openstack'
 
 # platforms:
  - name: centos-7
    driver:
      - image_ref: 'Add the name'
      - server_name: d1-kitchen-centos7-2_Tomcat

# Vagrant .kitchen.yml setting required: rename .kitchen.yml-vg to .kitchen.yml
  platforms:
    - name: rhel-7.5
    - name: centos-7

suites:
  - name: default
    run_list:
      - recipe[install_apache::default]
    
  
      
