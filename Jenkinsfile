pipeline {
    agent any
    environment {
        GIT_URL = "https://github.com/redsource03/"
        GIT_CREDS_ID = "Github-redsource"

        DEPLOYMENT_PROPERTIES_FILE = "deployment.properties"

        PROPERTIES_CONTAINER_PORT_KEY = "containerPort"
        PROPERTIES_SSL_PORT_KEY = "sslPort"
    }
    parameters {
        string(name: 'APPLICATION_NAME', defaultValue: '', description: 'Application name. Github Application name such as https://github.com/redsource03/${APPLICATION_NAME}')
        string(name: 'BPG_PIPELINE_BRANCH', defaultValue: 'master', description: 'BPG pipeline branch')
        string(name: 'GIT_BRANCH', defaultValue: 'master', description: 'git branch or tag to build')
        string(name: 'VERSION', defaultValue: '0.0.1-SNAPSHOT', description: 'project version')
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
                script {
                    sh "rm -rf ./$params.APPLICATION_NAME"
                    sh "mkdir $params.APPLICATION_NAME"
                }
                dir(params.APPLICATION_NAME){
                    checkout scm: [
                            $class           : 'GitSCM',
                            userRemoteConfigs: [[
                                                        credentialsId: "${GIT_CREDS_ID}",
                                                        url          : "${GIT_URL}${APPLICATION_NAME}.git"]],
                            branches         : [[name: "${GIT_BRANCH}"]]
                        ], poll: false
                        
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
                def appName = params.APPLICATION_NAME
                def sourcePath = env.workspace
                sh "cp ${sourcePath}/Dockerfile ."

                dir(params.APPLICATION_NAME) {
                    script {
                        def deploymentProps = loadDeploymentProperties(env.workspace + '/', env.DEPLOYMENT_PROPERTIES_FILE)
                        
                        buildDockerImage(deploymentProps,'dev')
                    }
                }
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

def loadDeploymentProperties(String path, String file) {
  def props = readProperties file: "${path}" + "${file}"
  return props
}

def buildDockerImage (def props, def environment) {
    def appName = params.APPLICATION_NAME
    def version = params.VERSION
    def containerPort = props["${appName}.${env.PROPERTIES_CONTAINER_PORT_KEY}"]
    def sslPort = props["${appName}.${env.PROPERTIES_SSL_PORT_KEY}"]

    sh "docker build -t ${appName}:${version} --build-arg version=${version} --build-arg projectName=${appName} --build-arg profile=${environment} --build-arg port=${containerPort} ."
}