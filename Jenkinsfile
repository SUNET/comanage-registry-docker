pipeline {
    agent any
    environment { 
        maintainer = "t"
        imagename = 'g'
        tag = 'l'
        version='3.2.5'
    }
    stages {
        stage('Setting build context') {
            steps {
                script {
                    maintainer = maintain()
                    imagename = imagename()
                    version= registryversion()
                    if(env.BRANCH_NAME == "master") {
                       tag = "latest"
                    } else {
                       tag = env.BRANCH_NAME
                    }
                    if(!imagename){
                        echo "You must define an imagename in common.bash"
                        currentBuild.result = 'FAILURE'
                     }
                } 
             }
        }    
        stage('Build and Push') {
            steps {
                script {
                   docker.withRegistry('https://registry.hub.docker.com/',   "dockerhub-$maintainer") {
                      def image_to_build
                      def image_dir
                      def build_arg

                      image_to_build = "comanage-registry-base:$version-1"
                      image_dir = 'comanage-registry-base'
                      build_arg = '--no-cache ' +
                                      "--build-arg COMANAGE_REGISTRY_VERSION=$version " +
                                      "-f ./$image_dir/Dockerfile ./$image_dir"
                      def base_image = docker.build("$image_to_build", "$build_arg")

                      image_to_build = 'comanage-registry-internet2-tier-base:1'
                      image_dir = 'comanage-registry-internet2-tier-base'
                      build_arg = '--no-cache ' +
                                      "-f ./$image_dir/Dockerfile ./$image_dir"
                      def tap_base_image = docker.build("$image_to_build", "$build_arg")

                      image_to_build = "$maintainer/$imagename"
                      image_dir = 'comanage-registry-internet2-tier'
                      build_arg = '--no-cache ' +
                                      "--build-arg COMANAGE_REGISTRY_VERSION=$version " + 
                                      "--build-arg COMANAGE_REGISTRY_BASE_IMAGE_VERSION=1 " +
                                      "--build-arg COMANAGE_REGISTRY_I2_BASE_IMAGE_VERSION=1 " + 
                                      "-f ./$image_dir/Dockerfile ./$image_dir"
                      def tap_image = docker.build("$image_to_build", "$build_arg")
                      tap_image.push("$tag")
                   }
               }
            }
        }
        stage('Notify') {
            steps{
                echo "$maintainer"
                slackSend color: 'good', message: "$maintainer/$imagename:$tag pushed to DockerHub"
            }
        }
    }
    post { 
        always { 
            echo 'In post.'
        }
        failure {
            // slackSend color: 'good', message: "Build failed"
            handleError("BUILD ERROR: There was a problem building ${maintainer}/${imagename}:${tag}.")
        }
    }
}


def maintain() {
  def matcher = readFile('common.bash') =~ 'maintainer="(.+)"'
  matcher ? matcher[0][1] : 'tier'
}

def imagename() {
  def matcher = readFile('common.bash') =~ 'imagename="(.+)"'
  matcher ? matcher[0][1] : null
}

def registryversion() {
  def matcher = readFile('common.bash') =~ 'COMANAGE_REGISTRY_VERSION="(.+)"'
  matcher ? matcher[0][1] : null
}


def handleError(String message){
  echo "${message}"
  currentBuild.setResult("FAILED")
  slackSend color: 'danger', message: "${message}"
  //step([$class: 'Mailer', notifyEveryUnstableBuild: true, recipients: 'chubing@internet2.edu', sendToIndividuals: true])
  sh 'exit 1'
}
