# cloud-orchestration-project-jenkins
Repositorio com a estrutura do servidor do Jenkins

Após iniciar uma instancia EC2 na AWS, clone este repositório, e na instancia do jenkins execute os seguintes comandos parta instalar o docker:
```
#!/bin/bash

sudo yum update -y
sudo yum install yum-utils -y

sudo yum install docker -y
sudo usermod -aG docker ec2-user

sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

sudo chkconfig docker on
sudo service docker start
```
Apos instalar o docker utilize o comando abaixo para configurar o servidor jenkins:
```
FROM jenkins/jenkins

USER root

RUN apt-get update && apt-get install wget -y

### Install Terraform ###
RUN wget --quiet https://releases.hashicorp.com/terraform/1.0.9/terraform_1.0.9_linux_amd64.zip \
&& unzip terraform_1.0.9_linux_amd64.zip \
&& mv terraform /usr/bin \
&& rm terraform_1.0.9_linux_amd64.zip

USER jenkins
```

Para buildar a imagem jenkins na instancia utilize: ```build -t jenkins-server-image```,  após isso crie o container do jenkins, mapeando a porta 80 da instancia para 8080 do container ```docker run -d -p 80:8080 --name jenkins-pod jenkins-server-image```.

Apos instalar todas as dependencias na instancia, entre no endereço do ip publico da instancia do jenkins

Para desbloquear o acesso ao jenkins utilize o seguinte comando na instancia para pegar a senha de administrtador 
```docker exec -ti jenkins-pod cat /var/jenkins_home/secrets/initialAdminPassword```

Ao abrir a pagina do jenkins escolha a opção de instalar os plugins recomendados

Quando finalizar a instalação, Preencha as informações de criação de usuario e clique em ```Save and Finish```

Com a pagina do Jenkins aberta, crie um job do tipo pipeline, ira abrir uma tela de configuração da pipeline, que deve ser preenhida com as seguintes informações no campo script:
```
pipeline {
agent any
  stages {
    stage('Clone') {
      steps {
        git url: 'https://github.com/m1nero/cloud-orchestration-project-jenkins;, branch: 'main'
      }
    }

    stage('TF Init&Plan') {
      steps {
        script {
          sh 'terraform init'
          sh 'terraform plan -out=myplan.out'
        }
      }
    }

    stage('Approval') {
      steps {
        script {
          def userInput = input(id: 'confirm', message: 'Deseja alterar a Infraestrutura?', description: 'Acao ', name: 'Confirm')
        }
      }
    }

    stage('TF Apply') {
      steps {
          sh 'terraform apply myplan.out'
      }
    }
  }
}
```

Apos isso clique em ```Save``` na tela de configurações da pipeline, e irá inicar o job
