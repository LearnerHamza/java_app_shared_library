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
 when { expression {  params.action == 'create' } }

        stage("checkout from SCM"){
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
            steps{
                script{

                    mvnTest()
                }
            }
        }
        stage('Integration Test maven'){
            steps{
               script{
                   
                   mvnIntegrationTest()
               }
            }
        }
        stage('Static code analysis: Sonarqube'){
            steps{
               script{
                   
                   def SonarQubecredentialsId = 'SonarCred'
                   statiCodeAnalysis(SonarQubecredentialsId)
               }
            }
        }
    }
}