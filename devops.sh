#!/bin/bash

# Função para exibir mensagens de status
status() {
    echo -e "\n\e[1;34m$1\e[0m\n"
}

# Marcar o DNS no host do Server
status "Configurando DNS"
server_ip=$(curl -4 icanhazip.com)
echo "Seu IP do servidor é: $server_ip"
read -p "Digite o subdomínio para configurar o DNS: " subdomain
dig +short $subdomain

# Pacotes de atualização e pré-requisitos de instalação
status "Atualizando e instalando pacotes"
sudo apt-get update && sudo apt upgrade -y
sudo apt-get -y install gnupg2 ca-certificates curl apt-transport-https iptables

# Instalar Helm V3
status "Instalando Helm V3"
curl https://baltocdn.com/helm/signing.asc | gpg --dearmor | sudo tee /usr/share/keyrings/helm.gpg > /dev/null
sudo apt-get install apt-transport-https --yes
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/helm.gpg] https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
sudo apt-get update
sudo apt-get install helm

# Instalar Minikube
status "Instalando Minikube"
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube
minikube start --extra-config=kubeadm.ignore-preflight-errors=NumCPU --force --cpus 1

# Instalar Docker
status "Instalando Docker"
sudo apt-get update
sudo apt-get install ca-certificates curl gnupg
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg
echo "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Instalar kubectl
status "Instalando kubectl"
sudo apt update
sudo apt install ca-certificates curl apt-transport-https -y
sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt update
sudo apt install kubectl -y
sudo snap install kubectl --classic

# Subir container Portainer
status "Subindo container Portainer"
docker run -d -p 8000:8000 -p 9443:9443 --name portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce:latest

# Subir docker do MySQL
status "Subindo container MySQL"
docker run -d -p 3306:3306 --name mysql-A -e MYSQL_ROOT_PASSWORD=Senha123 -e MYSQL_DATABASE=devops -e MYSQL_USER=admin -e MYSQL_PASSWORD=Senha123 mysql/mysql-server:latest

# Instalar GUI e server para acesso remoto
status "Instalando GUI e servidor para acesso remoto"
sudo apt update
sudo apt install x2goserver x2goserver-xsession
sudo apt install mate-core mate-desktop-environment mate-notification-daemon

# Subir cluster ArgoCD
status "Subindo cluster ArgoCD"
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# Mensagem de conclusão
status "Instalações concluídas com sucesso!"
