pipeline {
    agent { label "agent1" }
    stages {
        stage("build") {
            steps {
                sh "docker build -t jenkins_image -f Task4/Dockerfile ."         
            }
        }
        stage("run") {
            steps {
                sh "docker container run -d --name jenkins_image"                
            }
        }
    }
}