# nequi-techlead-challenge-iac

Infraestructura como código (IaC) para el desafío técnico del rol **Tech Lead** en Nequi.

Este repositorio contiene los archivos Terraform necesarios para aprovisionar la infraestructura de la aplicación de franquicias, incluyendo:

- Instancia EC2 para desplegar la aplicación Spring Boot (contenedor Docker).
- RDS (MySQL) para persistencia de datos.
- S3 y DynamoDB como backend remoto de Terraform (bloqueo de estado habilitado).
- Grupos de seguridad y red en una VPC personalizada.

---

## 📦 Estructura del repositorio

│   .gitignore
│   local.tf
│   main.tf
│   provider.tf
│   README.md
│
├───.github
│   └───workflows
│           terraform.yml
│
└───.scripts
        generate_ssh_key.sh
        terraform_s3_save_state.sh
