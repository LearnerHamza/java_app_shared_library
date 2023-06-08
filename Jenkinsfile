@Library('my_shared_lib') _

pipeline{
    agent any

    parameters{

        choice(name: 'action', choices: 'create\ndelete', description: 'Choose create/Destroy')
        string(name: 'IMAGE_NAME', description: "name of the docker build", defaultValue: 'javapp')
        string(name: 'IMAGE_TAG', description: "tag of the docker build", defaultValue: 'v1')
        string(name: 'DOCKERHUB_USERNAME', description: "name of the Application", defaultValue: 'zafarhamza')
    }

    stages{


         stage("checkout from SCM"){
            when { expression {  params.action == 'create' } }
            steps{
                script{
                    gitCheckout(
                    branch: "main",
                    url: "https://github.com/LearnerHamza/java_app_shared_library.git"
                    )
                }
            }
            }
                stage("Unit Test maven"){
                    when { expression {  params.action == 'create' } }
            steps{
                script{

                    mvnTest()
                }
            }
        }
        stage('Integration Test maven'){
            when { expression {  params.action == 'create' } }
            steps{
               script{
                   
                   mvnIntegrationTest()
               }
            }
        }
        stage('Static code analysis: Sonarqube'){
            when { expression {  params.action == 'create' } }
            steps{
               script{
                   
                   def SonarQubecredentialsId = 'SonarCred'
                   statiCodeAnalysis(SonarQubecredentialsId)
               }
            }
        }
     stage('Quality Gate Status Check : Sonarqube'){
         when { expression {  params.action == 'create' } }
            steps{
               script{
                   
                   def SonarQubecredentialsId = 'SonarCred'
                   QualityGateStatus(SonarQubecredentialsId)
               }
            }
        }

     stage('Maven Build : maven'){
         when { expression {  params.action == 'create' } }
            steps{
               script{
                   
                   mvnBuild()
               }
            }
        }
        stage('Docker Image Build'){
         when { expression {  params.action == 'create' } }
            steps{
               script{
                   
                   dockerBuild("${params.IMAGE_NAME}","${params.IMAGE_TAG}","${params.DOCKERHUB_USERNAME}")
               }
            }
        }
        stage('Docker Image Scan: trivy '){
         when { expression {  params.action == 'create' } }
            steps{
               script{
                   
                   dockerImageScan("${params.IMAGE_NAME}","${params.IMAGE_TAG}","${params.DOCKERHUB_USERNAME}")
               }
            }
        }
        // stage("Push docker image into ACR"){
        //     steps{
        //         script{


        //         }
        //     }
        // }
        stage('Docker Image Push : DockerHub '){
         when { expression {  params.action == 'create' } }
            steps{
               script{
                   
                   dockerImagePush("${params.IMAGE_NAME}","${params.IMAGE_TAG}","${params.DOCKERHUB_USERNAME}")
               }
            }
        }   
        stage('Docker Image Cleanup : DockerHub '){
         when { expression {  params.action == 'create' } }
            steps{
               script{
                   
                   dockerImageCleanup("${params.IMAGE_NAME}","${params.IMAGE_TAG}","${params.DOCKERHUB_USERNAME}")
               }
            }
        }  

        stage("Connect to AKS"){
            steps{
                script{

                    sh """
                        az login
                        az account set --subscription 91a478a4-1079-48c8-801a-739d7da0bad4
                        az aks get-credentials --resource-group Demo_Project --name k8cluster

                    """
                }
            }
        }   
        stage('Deployment on EKS Cluster'){
            when { expression {  params.action == 'create' } }
            steps{
                script{
                  
                  def apply = false

                  try{
                    input message: 'please confirm to deploy on Aks', ok: 'Ready to apply the config ?'
                    apply = true
                  }catch(err){
                    apply= false
                    currentBuild.result  = 'UNSTABLE'
                  }
                  if(apply){

                    sh """
                      kubectl apply -f .
                    """
                  }
                }
            }
        }  
        stage("Kubernets Deploy"){
             steps{
                script{
                    KubernetsDeploy(
                         configs: 'deployment.yaml'
                         kubeconfigId: 'K8s'//Kubenetes secret id name
                         enableConfigSubstitution: false
                     )
                 }
             }
         }   
    }
    post {
		always {
			mail bcc: '', body: "<br>Project: ${env.JOB_NAME} <br>Build Number: ${env.BUILD_NUMBER} <br> URL de build: ${env.BUILD_URL}", cc: '', charset: 'UTF-8', from: '', mimeType: 'text/html', replyTo: '', subject: "${currentBuild.result} CI: Project name -> ${env.JOB_NAME}", to: "itsdemoid20@gmail.com";  
		}
	}
}    
