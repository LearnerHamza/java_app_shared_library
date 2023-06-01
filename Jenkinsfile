@Library('my_shared_lib') _

pipeline{
    agent any

    stages{

        stage("checkout from SCM"){
            steps{
                script{

                    def GitcredentialsId = "GitHub_Password"
                    gitCheckout(
                    GitcredentialsId,
                    branch: "main",
                    url: "https://github.com/LearnerHamza/java_app_shared_library.git"
                    )
                }
            }
        }
    }
}