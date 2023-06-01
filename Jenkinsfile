@Library('my_shared_lib') _

pipeline{
    agent any

    stages{

        stage("checkout from SCM"){
            steps{
                script{

                    git credentialsId = "GitHub_Password"
                    gitCheckout(
                    branch: "main",
                    url: "https://github.com/LearnerHamza/java_app_shared_library.git"
                    )
                }
            }
        }
    }
}