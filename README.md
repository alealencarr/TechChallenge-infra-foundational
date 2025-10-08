# TechChallenge - Base de Infra no Azure
Rede Virtual (VNet) com as suas sub-redes, e a Conta de Armazenamento para o estado remoto do Terraform.

[Documentação completa do projeto](https://alealencarr.github.io/TechChallenge/)

### Descrição
Este repositório é a fundação de toda a nossa infraestrutura na Azure. Ele é responsável por criar os recursos de base, partilhados e de longa duração, sobre os quais todos os outros serviços serão construídos.

A principal responsabilidade deste repositório é garantir um ambiente de rede seguro e isolado, e configurar o backend de estado remoto para o Terraform, garantindo consistência e colaboração.

### Tecnologias Utilizadas
Terraform: Ferramenta de Infraestrutura como Código (IaC).

Azure CLI: Para a criação inicial do storage account do backend.

Azure Resources:

Resource Group

Virtual Network (VNet) e Subnets

Storage Account (para o estado remoto do Terraform)

### Responsabilidades
Criar o Grupo de Recursos principal (rg-tchungry-prod) onde todos os outros recursos da aplicação irão residir.

Definir e criar a Rede Virtual (VNet) principal e as sub-redes necessárias para isolar os nossos serviços (ex: uma sub-rede para o AKS, outra para o APIM).

Criar a Conta de Armazenamento e o Contêiner de Blob dedicados a guardar os ficheiros de estado (.tfstate) do Terraform de todos os outros projetos de infraestrutura.

### Dependências
Nenhuma. Este é o primeiro repositório a ser executado no fluxo de deploy da infraestrutura.

### Processo de CI/CD
O pipeline de CI/CD (.github/workflows/deploy-infra.yml) automatiza a gestão da infraestrutura:

Em Pull Requests: Executa terraform plan para validar as alterações e mostrar o impacto previsto, sem aplicar nada.

Em Merges na main: Executa terraform apply para aplicar as alterações e provisionar/atualizar os recursos no Azure.
