pipeline {
    agent any
    environment {
        AWS_ACCESS_KEY_ID = credentials('Jenkins') // ID from Jenkins credentials store
        AWS_SECRET_ACCESS_KEY = credentials('Jenkins') // ID from Jenkins credentials store
     }
    stages {
        

        stage('Checkout') {
            steps {
                deleteDir()
                sh 'echo cloning repo'
                sh 'git clone https://github.com/venugopalsimma/jenkins-terraform-ansible-task.git' 
            }
        }
        
        stage('Terraform Apply') {
            steps {
                script {
                    dir('/var/lib/jenkins/workspace/Ansible/jenkins-terraform-ansible-task') {
                    sh 'pwd'
                    sh 'terraform init'
                    sh 'terraform validate'
                    // sh 'terraform destroy -auto-approve'
                    sh 'terraform plan'
                    sh 'terraform apply -auto-approve'
                    sh 'done'
                    }
                }
            }
        }
        
        stage('Ansible Deployment') {
            steps {
                script {
                   sleep '160'
                    ansiblePlaybook becomeUser: 'ec2-user', credentialsId: 'amazonlinux', disableHostKeyChecking: true, installation: 'ansible', inventory: '/var/lib/jenkins/workspace/Ansible/jenkins-terraform-ansible-task/inventory.yaml', playbook: '/var/lib/jenkins/workspace/Ansible/jenkins-terraform-ansible-task/amazon-playbook.yml', vaultTmpPath: ''
                    ansiblePlaybook become: true, credentialsId: 'ubuntuuser', disableHostKeyChecking: true, installation: 'ansible', inventory: '/var/lib/jenkins/workspace/Ansible/jenkins-terraform-ansible-task/inventory.yaml', playbook: '/var/lib/jenkins/workspace/Ansible/jenkins-terraform-ansible-task/ubuntu-playbook.yml', vaultTmpPath: ''
                }
            }
        }
    }
}
