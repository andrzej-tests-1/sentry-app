pipeline {
    agent any
    environment {
        CLOUDSDK_CORE_PROJECT = credentials('CLOUDSDK_CORE_PROJECT')
        CLUSTER_NAME = credentials('CLUSTER_NAME')
        CLUSTER_ZONE = credentials('CLUSTER_ZONE')
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
