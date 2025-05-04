# nequi-techlead-challenge-iac

Infraestructura como código (IaC) para el desafío técnico del rol **Tech Lead** en Nequi.

Este repositorio contiene los archivos y configuraciones necesarias para desplegar una arquitectura en AWS, incluyendo:

- Instancia de EC2 con Docker para correr el backend.
- Base de datos MySQL en Amazon RDS.
- Bucket S3 y tabla DynamoDB para almacenar y bloquear el estado de Terraform.
- Automatización de despliegue con GitHub Actions.

---

## 📦 Estructura del repositorio

```
.
├── .github/workflows/terraform.yml       # Pipeline de GitHub Actions para Terraform
├── .scripts/
│   ├── generate_ssh_key.sh               # Script para generar llave SSH
│   └── terraform_s3_save_state.sh        # Script para crear bucket S3 y tabla DynamoDB
├── main.tf
├── provider.tf
├── variables.tf
├── local.tf
└── README.md
```

---

## 🚀 ¿Cómo ejecutar el proyecto?

### 1. Instala y configura las credenciales de AWS

Instala AWS CLI y ejecuta:

```bash
aws configure
```

Agrega tu:
- AWS Access Key
- AWS Secret Access Key
- Región (ej. `us-east-1`)

---

### 2. Genera la llave SSH para tu instancia EC2

```bash
sh .\.scripts\generate_ssh_key.sh  
```

Esto creará una clave en la raiz del proyecto `./.ssh/key-nequi-techlead-challenge` que se usará en el recurso EC2.

---

### 3. Configuración local y/o remota del terraform state

#### 3.1. Ejecutar la IaC localmente

Si desea correr el proyecto localmente, vaya al archivo provider.tf y reemplace la linea `backend "s3" {...}` por `backend "local" {}`.

El archivo debería verse algo así:

```bash
terraform {
  required_version = ">= 1.6.6"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.31.0"
    }
  }
  backend "local" {}
}

provider "aws" {
  region  = "us-east-1"
  alias   = "main"
}
```

#### 3.2. Ejecutar la IaC vía pipeline

##### 3.2.1 Crea el bucket de S3 y la tabla DynamoDB para Terraform

```bash
sh .\.scripts\terraform_s3_save_state.sh
```

Este script:
- Crea el bucket `s3-nequi-techlead-challenge-terraform`
- Crea la tabla `dynamo-nequi-techlead-challenge-terraform-lock` para el bloqueo de estado de terraform

---

### 4. Inicializa Terraform

```bash
terraform init
```

Esto configura el backend remoto con S3 y DynamoDB.

---

### 5. Ejecuta Terraform Plan (opcional)

```bash
terraform plan
```

Verifica los recursos que se van a crear.

---

### 6. Aplica la infraestructura

```bash
terraform apply -auto-approve
```

---

## 🤖 Despliegue con GitHub Actions

Este repositorio incluye un workflow en `.github/workflows/terraform.yml` que permite desplegar o destruir la infraestructura desde la UI de GitHub.

### ¿Cómo funciona?

- El workflow se activa manualmente (`workflow_dispatch`).
- Acepta dos opciones:
  - `Terraform_apply` → crea/actualiza la infraestructura.
  - `Terraform_destroy` → destruye la infraestructura.

### Requisitos para GitHub Actions

Debes definir los siguientes *secrets* en GitHub:

- `AWS_ACCESS_KEY_ID`
- `AWS_SECRET_ACCESS_KEY`
- `AWS_REGION`

---

## 🛠️ Ejemplo de ejecución desde GitHub

1. Ve a la pestaña **Actions** de tu repositorio.
2. Selecciona el workflow **Terraform**.
3. Haz clic en **Run workflow**.
4. Selecciona `Terraform_apply` o `Terraform_destroy`.

---

## 📌 Notas

- El estado de Terraform se almacena en un bucket S3 con bloqueo habilitado vía DynamoDB.
- La infraestructura puede ser destruida fácilmente usando `terraform destroy` o el workflow.
- Esta solución está pensada para ser **rápida, modular y fácilmente desplegable en la nube** como parte del reto técnico.