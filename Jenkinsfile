pipeline {
  options {
        buildDiscarder(logRotator(numToKeepStr:'10'))
        timestamps()
        ansiColor('xterm')
    }
  agent { label 'chef-workstation' }
  stages {
    stage('Setup') {
      steps {
        sh 'mkdir -p ~/.chef'
        sh """
cat <<EOF > ~/.chef/config.rb
current_dir = File.dirname(__FILE__)
syntax_check_cache_path  "#{ENV['HOME']}/.chef/syntax_check_cache"
ssl_verify_mode :verify_none
        """
        sh """
cat <<EOF > ~/.chef/credentials
[chef_server_dummy]
node_name = "user_pipeline"
client_key = "user_pipeline.pem"
chef_server_url = "https://chef-server.com/organizations/ReplaceItWithYour_ORG"
"""
        sh 'echo "Versions: "'
        sh 'chef env --chef-license accept'
        sh 'chef --version'
        sh 'cookstyle --version'
        sh 'cat /root/.chef/credentials'
        //sh 'cat /root/.chef/user_pipeline.pem'
      }
    }
    stage('Acceptance Testing') {
      when {
        allOf {
          branch 'PR-*'
        }
      }
      steps {
        parallel(
          Cookstyle: {
            sh 'echo "Starting cookstyle: "'
            sh 'cookstyle'
          },
        )
      }
    }
    stage('Test Kitchen') {
    when {
      allOf {
        branch 'PR-*'
      }
    }
    environment {
      KEY_NAME = 'cloud-key'
      KITCHEN_KEY = '/root/.ssh/id_rsa'
      http_proxy = 'ADD YOUR PROXY-SERVER:8080'
      https_proxy = 'ADD YOUR PROXY-SERVER:8080'
      no_proxy = 'IF NEEDED'
    }
    steps {
      script {
        json = vaultGetSecrets()
        env.P9_USER=json.P9_USER
        env.P9_PWD=json.P9_PWD
       	sh "export CHEF_PROFILE=chef_server_dummy; chef exec kitchen test -d always --color -c 10"
        sh "/root/suma_delete_system d1-kitchen-centos7-hpe_base_linux"
        sh "/root/suma_delete_system d1-kitchen-rhel7-hpe_base_linux"
      }
     }
    }
     stage('Generate Lock File') {
      when {
        allOf {
          branch 'master'
        }
      }
      environment {
      http_proxy="ADD YOUR PROXY-SERVER:8080"
      https_proxy="ADD YOUR PROXY-SERVER:8080"
    }
      steps {
        sh """
          export CHEF_PROFILE=chef_server_dummy
          chef install Policyfile.rb
          chef export -a Policyfile.rb ./
        """
      }
    }
    stage('Approve Deployment to deploy?') {
      when {
        allOf {
          branch 'master'
        }
      }
      input {
        message 'Deploy to Default Group?'
        submitter "ayman-mousa"
        parameters {
          string(name: 'APPROVER_NAME', defaultValue: 'NAME', description: 'Who is the user approving this deployment in Jenkins')
          string(name: 'SNOW_TICKET_NUMBER', defaultValue: 'TICKETNUMBER', description: 'What is the approved SNOW CHG Ticket Number')
        }
      }
      steps {
        echo "Approver's name: $APPROVER_NAME"
        echo "ServiceNow Change Ticket Number: $SNOW_TICKET_NUMBER"
      }
    }
    stage('Default Deployment') {
      when {
        allOf {
          branch 'master'
        }
      }
      steps {
        sh """
          export CHEF_PROFILE="chef_server_dummy"
          chef push-archive default ./*.tgz
           """  
          """
      }
    }
    stage('Save Policy Revision Archive') {
      when {
        allOf {
          branch 'master'
        }
      }
      steps {
        // Update this so that it saves to an Artifactory Repository
        sh """
          mkdir -p /var/lib/jenkins/chef_policyfile_archives/
          cp -a ./*.tgz /var/lib/jenkins/chef_policyfile_archives/
        """
      }
    }
  }
  post {
  success {
    sh "echo 'success'"
  }
  always {
        deleteDir()
    }
}
}
