#!groovy

pipeline {
    agent {
        node {
            label 'java'
        }
    }
    tools {
        gradle 'gradle-6.0.1'
        jdk 'jdk-11'
    }
    stages {
        stage('Clean workspace') {
            steps {
                cleanWs()
            }
        }
        stage('Git checkout') {
            steps {
                git branch: 'master',
                        credentialsId: 'jenkins-ssh',
                        url: 'ssh://git@github.com:jfrog/auto-mat.git'
            }
        }
        stage('Bump and set version') {
            steps {
                script {
                    sh 'docker run --rm -v $PWD:/app -w /app treeder/bump --filename version.txt'
                }
                script {
                    version = readFile 'version.txt'
                }
            }
        }
        stage('docker build') {
            steps {
                script {
                    sh "docker build . -t jfrog-docker-reg2.bintray.io/jfrog/auto-mat:${version} -t jfrog-docker-reg2.bintray.io/jfrog/auto-mat:latest"
                }
            }
        }
        stage('test') {
            steps {
                script {
                    sh "gradle build test -i"
                }
            }
        }
        stage('docker push') {
            steps {
                script {
                    sh '#!/bin/sh -e\n' + 'echo $BINTRAY_KEY | docker login --username=$BINTRAY_USER --password-stdin jfrog-docker-reg2.bintray.io/jfrog'
                    sh "docker push jfrog-docker-reg2.bintray.io/jfrog/auto-mat:${version}"
                    sh "docker push jfrog-docker-reg2.bintray.io/jfrog/auto-mat:latest"
                }
            }
        }
        stage('commit version change') {
            steps {
                script {
                    sh "git commit -m 'auto version bump' -- version.txt"
                    sh "git push --set-upstream origin master"
                }
            }
        }
    }
    post {
        always {
            junit 'build/test-results/**/*.xml'
        }
    }

}