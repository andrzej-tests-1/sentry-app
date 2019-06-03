pipeline {
    agent any
    environment {
        CLOUDSDK_CORE_PROJECT = credentials('CLOUDSDK_CORE_PROJECT')
    }

    stages {
        stage('Build`') {
            steps {
                sh 'bin/build.sh'
            }
        }
        stage('Deploy`') {
            steps {
                sh 'bin/deploy.sh'
            }
        }
        stage('Test`') {
            steps {
                sh 'echo TO BE DONE'
            }
        }
    }
}
