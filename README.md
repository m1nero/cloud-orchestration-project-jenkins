# cloud-orchestration-project-jenkins
Repositorio com a estrutura do servidor do Jenkins

Após iniciar uma instancia EC2 na AWS, clone este repositório, e entre no endereço do ip publico da instancia do jenkins

Ao abrir a pagina do jenkins escolha a  opção de instalar os plugins recomendados

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
