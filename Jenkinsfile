@Library('my_shared_lib') _

pipeline{
    agent any

    stages{

        stage("checkout from SCM"){
            steps{
                script{

                    def GitcredentialsId = "credentialsId"
                    gitCheckout(
                    GitcredentialsId,
                    branch: "main",
                    credentialsId: "GitHub_Password",
                    url: "https://github.com/LearnerHamza/java_app_shared_library.git"
                    )
                }
            }
        }
    }
}