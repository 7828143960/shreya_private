package org.terraform

def call(String rootPath, String childPath, string ACTION) {
    stage("Terraform Plan") {
        script {
            sh "cd ${rootPath}/${childPath} && terraform plan"
        }
    }
    
    if (ACTION == 'apply') {
        stage('Approval For Apply') {
            script {
                // Prompt for approval before applying changes
                input "Do you want to apply Terraform changes?"
            }
        }

    stage('Terraform Apply') {
        script {
            // Run Terraform apply
            sh 'cd ${rootPath}/${childPath} && terraform apply -auto-approve'
        }
    }
} 

