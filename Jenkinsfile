pipeline {
    environment {
        CLOUDSDK_CORE_PROJECT = credentials('CLOUDSDK_CORE_PROJECT')
        CLUSTER_NAME = credentials('CLUSTER_NAME')
        CLUSTER_ZONE = credentials('CLUSTER_ZONE')
    }
    agent { node { label 'generalbuilds' } }

    stages {
        stage('Build`') {
            steps {
                sh 'bin/build.sh'
            }
        }
        stage('Deploy`') {
            steps {
                sh '. bin/deploy.sh'
                stash name:'envrandom', includes:'envrandom'
            }
        }
        stage('Test`') {
            steps {
                unstash 'envrandom'
                sh 'source ./envrandom ; curl -Is -m 2 http://$(~/google-cloud-sdk/bin/kubectl get svc --namespace default $PROJECT-$VERSION-$RANDOMID -o jsonpath=\'{.status.loadBalancer.ingress[0].ip}\'):9000/_health/ | grep "HTTP/1.1 200 OK"'
            }
        }
    }
}
