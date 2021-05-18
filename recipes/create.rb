#
# Cookbook:: 2_Tomcat
# Recipe:: create
#
# Virtual Hosts Files
# Copyright:: N/A

group "apacheadim" do
  gid 9999
end


user 'apacheadim' do
  comment 'Admin [at] target_node'
  uid '9999'
  gid '9999'
  manage_home true
  home '/home/apacheadim'
  shell '/bin/bash'
  password 'user oppenssl to generate password has key'
end