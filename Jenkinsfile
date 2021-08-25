pipeline {
    agent { label "agent1" }
    stages {
        stage("build") {
            steps {
                sh "docker build -t jenkins_image /Task4/"         
            }
        }
        stage("run") {
            steps {
                sh "docker run -rm jenkins_image"                
            }
        }
    }
}