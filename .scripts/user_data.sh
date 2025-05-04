#!/bin/bash
# ============================
# EC2 Instance Initialization
# ============================

# 1. Actualiza el índice de paquetes del sistema
# Esto asegura que los paquetes estén en su última versión conocida por el sistema.
sudo apt update -y

# 2. Realiza una actualización completa de los paquetes instalados
sudo apt upgrade -y

# 3. Instala dependencias necesarias para usar repositorios HTTPS
sudo apt install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common \
    gnupg-agent

# 4. Agrega la clave GPG oficial de Docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# 5. Agrega el repositorio oficial de Docker al sistema
echo \
  "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] \
  https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# 6. Actualiza el índice de paquetes nuevamente para incluir el nuevo repositorio
sudo apt update -y

# 7. Instala Docker CE (Community Edition)
sudo apt install -y docker-ce docker-ce-cli containerd.io

# 8. Habilita Docker para que se inicie automáticamente con el sistema
sudo systemctl enable docker

# 9. Inicia el servicio Docker (por si aún no ha arrancado)
sudo systemctl start docker

# 10. Agrega el usuario 'ubuntu' al grupo 'docker' (opcional, evita usar 'sudo' con docker)
sudo usermod -aG docker ubuntu

# Mensaje final
echo "✅ Docker instalado correctamente y listo para usarse."