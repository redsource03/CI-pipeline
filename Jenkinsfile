pipeline {
    agent any
    environment {
        GIT_URL = "https://github.com/redsource03/"
    }
    parameters {
        string(name: 'APPLICATION_NAME', defaultValue: '', description: 'Application name. Github Application name such as https://github.com/redsource03/${APPLICATION_NAME}')
        string(name: 'BPG_PIPELINE_BRANCH', defaultValue: 'master', description: 'BPG pipeline branch')
        string(name: 'GIT_BRANCH', defaultValue: 'master', description: 'git branch or tag to build')
        string(name: 'ECS_TIMEOUT', defaultValue: '20', description: 'Timeout value of deployment to ECS in minutes')

        booleanParam(name: 'DEPLOY_TO_DEV', defaultValue: true, description: 'Deploy to Dev Environment?')
        booleanParam(name: 'RUN_REGRESSION', defaultValue: false, description: 'Run Regression Test')
        booleanParam(name: 'DEPLOY_TO_TEST', defaultValue: false, description: 'Deploy to Test Environment?')
        booleanParam(name: 'DEPLOY_TO_PERF', defaultValue: false, description: 'Deploy to Perf Environment?')
        booleanParam(name: 'DEPLOY_TO_STAGING', defaultValue: false, description: 'Deploy to Staging Environment?')
        booleanParam(name: 'DEPLOY_TO_PROD', defaultValue: false, description: 'Deploy to Production Environment?')
    }
    stages {
        stage('Git Checkout') {
            steps {
                echo 'Pulling Project from Git..'
                dir(params.APPLICATION_NAME){
                    git(
                        url: "${GIT_URL}${APPLICATION_NAME}.git",
                        credentialsId: 'Github-redsource',
                        branch: "${GIT_BRANCH}"
                    )    
                }
            }
        }
        stage('Build') {
            steps {
                echo 'Building Application'
                dir(params.APPLICATION_NAME){
                    script {
                        sh 'chmod +x gradlew'
                        sh './gradlew clean build'     
                    }
                }
                
                 
            }
        }
        stage('Deploy Dev') {
            when {
                expression {
                    return params.DEPLOY_TO_DEV
                }
            }
            steps {
                echo 'Deploying to Dev environment'
            }
        }
    }
    
    post { 
        always {
            echo 'Cleaning workspace...' 
            cleanWs()
        }
    }
}
