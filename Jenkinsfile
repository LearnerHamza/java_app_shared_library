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
        // stage('Docker Image Cleanup : DockerHub '){
        //  when { expression {  params.action == 'create' } }
        //     steps{
        //        script{
                   
        //            dockerImageCleanup("${params.IMAGE_NAME}","${params.IMAGE_TAG}","${params.DOCKERHUB_USERNAME}")
        //        }
        //     }
        // }  

        stage("Connect to AKS"){
            steps{
                script{

                    sh """
                        sudo apt install azure-cli -y
                        az login
                        az account set --subscription 91a478a4-1079-48c8-801a-739d7da0bad4
                        az aks get-credentials --resource-group Demo_Project --name k8cluster

                    """
                }
            }
        }    
    }
}    