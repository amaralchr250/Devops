<h1 align="center"> Devops </h1>

<h4 align="center"> 
    :construction:  Projeto em construção  :construction:
</h4>

Auxiliar os inciantes a montar o melhor ambiente de estudo.

### Segue as instalações e o passo-a-passo em ordem

### Marcar o DNS no host do Server:
````
curl -4 icanhazip.com
````
### Direcionar ao seu provedor de DNS e crie um registro :
````
dig +short replace_with_subdomain
````
### Pacotes de atualização e pré-requisitos de instalação
````
sudo apt-get update && sudo apt upgrade -y
sudo apt-get -y install gnupg2 ca-certificates curl apt-transport-https iptables
````
### Instalar Helm V3
Link- https://helm.sh/docs/intro/install/
````
curl https://baltocdn.com/helm/signing.asc | gpg --dearmor | sudo tee /usr/share/keyrings/helm.gpg > /dev/null
sudo apt-get install apt-transport-https --yes
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/helm.gpg] https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
sudo apt-get update
sudo apt-get install helm
````
### Instalar kubectl
Link- https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/
````
sudo apt update
sudo apt install ca-certificates curl apt-transport-https -y
sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt update
sudo apt install kubectl -y
snap install kubectl --classic
````
### Instalar Minikube
Link - https://minikube.sigs.k8s.io/docs/start/
````
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube
minikube start --extra-config=kubeadm.ignore-preflight-errors=NumCPU --force --cpus 1
````
### Instalar Docker
Link - https://docs.docker.com/engine/install/ubuntu/
````
 sudo apt-get update
 sudo apt-get install ca-certificates curl gnupg
 sudo install -m 0755 -d /etc/apt/keyrings
 curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
 sudo chmod a+r /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
 sudo apt-get update
 sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
````
### Subir container e vamos estar usando o Portainer como teste
Link - https://docs.portainer.io/start/install-ce/server/docker/linux
````
docker run -d -p 8000:8000 -p 9443:9443 --name portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce:latest
````
### Vamos instalar GUI e também um server para acesso remoto do nossa instância
Link - https://bytexd.com/x2go-ubuntu/
````
sudo apt update
sudo apt install x2goserver x2goserver-xsession
sudo apt install mate-core mate-desktop-environment mate-notification-daemon
````
### Vamos subir um docker do Mysql
Link - https://www.appsdeveloperblog.com/how-to-start-mysql-in-docker-container/
````
docker run -d -p 3306:3306 --name mysql-A -e MYSQL_ROOT_PASSWORD=Senha123 -e MYSQL_DATABASE=devops -e MYSQL_USER=admin -e MYSQL_PASSWORD=Senha123 mysql/mysql-server:latest
````
### Vamos agora subir nosso cluster de ArgoCD
Link - https://github.com/badtuxx/DescomplicandoArgoCD/blob/main/pt/src/day-1/README.md#conte%C3%BAdo-do-day-1

Para instalar o ArgoCD como um operador no Kubernetes, antes precisamos criar uma namespace chamada `argocd`, e para isso basta executar o seguinte comando:

```bash
kubectl create namespace argocd
```

&nbsp;

A saída desse comando será algo parecido com isso:

```bash
namespace/argocd created
```

Agora vamos instalar o ArgoCD como um operador no Kubernetes:

```bash
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
```

&nbsp;

Como você pode ver, com o comando acima configuramos o ArgoCD através da criação de vários objetos no Kubernetes, como por exemplo, um `deployment` para o `argocd-server`, um `service` para o `argocd-server`, um `configmap` para o `argocd-cm`, e por aí vai.

Caso você queira conhecer mais sobre o projeto, vá até o [repositório oficial](https://github.com/argoproj/argo-cd)

&nbsp;

Vamos ver se os pods do ArgoCD foram criados com sucesso:

```bash
kubectl get pods -n argocd
```

&nbsp;

A saída desse comando será algo parecido com isso:

```bash
NAME                                                READY   STATUS    RESTARTS   AGE
argocd-application-controller-0                     1/1     Running   0          115s
argocd-applicationset-controller-5f67f4c987-vdtpr   1/1     Running   0          117s
argocd-dex-server-5859d89dcc-c69fx                  1/1     Running   0          117s
argocd-notifications-controller-75c986587-7jznn     1/1     Running   0          116s
argocd-redis-74c8c9c8c6-mzdlv                       1/1     Running   0          116s
argocd-repo-server-76f77874d7-8qscp                 1/1     Running   0          116s
argocd-server-64d5654c48-tkv65                      1/1     Running   0          116s
```

&nbsp;

Onde temos os seguintes pods:

* argocd-application-controller-0 - Responsável por gerenciar os recursos do Kubernetes
* argocd-applicationset-controller-5f67f4c987-vdtpr - Controller responsável por gerenciar os `ApplicationSets`
* argocd-dex-server-5859d89dcc-c69fx - Responsável por gerenciar a autenticação
* argocd-notifications-controller-75c986587-7jznn - Responsável por gerenciar as notificações, como por exemplo, quando um `Application` é atualizado
* argocd-redis-74c8c9c8c6-mzdlv - Responsável por armazenar os dados do ArgoCD
* argocd-repo-server-76f77874d7-8qscp - Responsável por gerenciar os repositórios
* argocd-server-64d5654c48-tkv65 - Responsável por expor a interface gráfica do ArgoCD

&nbsp;

Pronto, apresentados. No decorrer do livro iremos falar mais sobre cada um desses componentes, mas por agora é o que você precisa saber.

Todos os nossos podes estão com o status `Running`, o que significa que eles estão funcionando corretamente.

&nbsp;

## Instalando o ArgoCD CLI

Como eu falei, o ArgoCD possui uma interface gráfica, mas também é possível interagir com ele através de comandos. Para isso, precisamos instalar o `argocd` CLI.

Nós vamos focar a primeira parte desse livro no CLI, para que você consiga entender como funciona o ArgoCD por baixo dos panos, e depois sim, se delicie com a interface gráfica.

Para instalar o `argocd` CLI no Linux, basta executar o seguinte comando:

```bash
curl -sSL -o argocd-linux-amd64 https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64

sudo install -m 555 argocd-linux-amd64 /usr/local/bin/argocd

rm argocd-linux-amd64
```

&nbsp;

Com o comando acima fizemos o download do binário do `argocd` CLI, e o instalamos no diretório `/usr/local/bin/argocd`, para fazer a instalação utilizamos o comando `install` do Linux, que é um comando que faz a instalação de arquivos e diretórios. Passamos os parâmetros `-m 555` para definir as permissões do arquivo, e o nome do arquivo que queremos instalar.

Pronto! O nosso `argocd` CLI está instalado.

Vamos ver se ele está funcionando corretamente:

```bash
argocd version
```

&nbsp;

Qual a versão do `argocd` CLI que você está utilizando? Comenta lá no Twitter e me marca para eu saber como está sendo essa sua abordagem com o ArgoCD. @badtux_, esse é o meu arroba lá no Twitter.

&nbsp;

## Autenticando no ArgoCD

Agora que já temos o ArgoCD instalado, tanto o CLI quanto o operador, precisamos fazer a autenticação no ArgoCD para que possamos dar os primeiros passos.

Antes de mais nada, precisamos saber qual o endereço do ArgoCD. Para isso, vamos executar o seguinte comando:

```bash
kubectl get svc -n argocd
```

&nbsp;

A saída desse comando será algo parecido com isso:

```bash
NAME                                      TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)                      AGE
argocd-applicationset-controller          ClusterIP   10.100.164.34    <none>        7000/TCP,8080/TCP            12m
argocd-dex-server                         ClusterIP   10.100.14.112    <none>        5556/TCP,5557/TCP,5558/TCP   12m
argocd-metrics                            ClusterIP   10.100.146.115   <none>        8082/TCP                     12m
argocd-notifications-controller-metrics   ClusterIP   10.100.81.159    <none>        9001/TCP                     12m
argocd-redis                              ClusterIP   10.100.174.178   <none>        6379/TCP                     12m
argocd-repo-server                        ClusterIP   10.100.148.141   <none>        8081/TCP,8084/TCP            12m
argocd-server                             ClusterIP   10.100.25.239    <none>        80/TCP,443/TCP               12m
argocd-server-metrics                     ClusterIP   10.100.46.64     <none>        8083/TCP                     12m
```

&nbsp;

O service que precisamos por agora do ArgoCD é o `argocd-server`, e o endereço completo é `argocd-server.argocd.svc.cluster.local`.

Vamos fazer o port-forward para acessar o ArgoCD sem precisar expor:

```bash
kubectl port-forward svc/argocd-server -n argocd 8080:443
```

&nbsp;

Pronto, agora podemos acessar o ArgoCD através do endereço `localhost:8080`, tanto pelo navegador quanto pelo CLI.

Vamos continuar com a nossa saga utilizando o CLI, então vamos fazer a autenticação no ArgoCD.

Para fazer a autenticação no ArgoCD, precisamos executar o seguinte comando:

```bash
argocd login localhost:8080
```

&nbsp;

Perceba que ele irá pedir o usuário e a senha, mas não se preocupe, pois o usuário padrão do ArgoCD é o `admin`, e a senha inicial está armazenada em um secret, então vamos executar o seguinte comando para pegar a senha:

```bash
kubectl get secret argocd-initial-admin-secret -n argocd -o jsonpath="{.data.password}" | base64 -d
```

&nbsp;

A saída será a sua senha inicial, copie ela para que possamos utilizar no próximo comando:

```bash
argocd login localhost:8080
WARNING: server certificate had error: x509: certificate signed by unknown authority. Proceed insecurely (y/n)? y
Username: admin
Password: 
'admin:login' logged in successfully
Context 'localhost:8080' updated
```

&nbsp;

Pronto, estamos autenticados no ArgoCD. Agora vamos adicionar o nosso cluster Kubernetes ao ArgoCD.

Para isso, vamos ver qual o contexto do nosso cluster Kubernetes:

```bash
kubectl config current-context
```

&nbsp;

A saída será algo parecido com isso:

```bash
minikube
```

&nbsp;

Isso no meu caso que somente estou utilizando um cluster e é um EKS, lá da AWS.

Agora vamos adicionar o nosso cluster ao ArgoCD:

```bash
argocd cluster add O_NOME_DO_SEU_CONTEXT
```

&nbsp;

No meu caso:
    
```bash
argocd cluster add minikube
``` 

&nbsp;

A saída será algo parecido com isso:

```bash
WARNING: This will create a service account `argocd-manager` on the cluster referenced by context `girus@eks-cluster.us-east-1.eksctl.io` with full cluster level privileges. Do you want to continue [y/N]? y
INFO[0005] ServiceAccount "argocd-manager" created in namespace "kube-system" 
INFO[0005] ClusterRole "argocd-manager-role" created    
INFO[0005] ClusterRoleBinding "argocd-manager-role-binding" created 
```

&nbsp;

Caso esteja utilizando um cluster k8s no mesmo host em que está executando o kubectl, como é o que acontece quando usamos um cluster via kind ou minikube por exemplo, você pode ter o seguinte erro:

```bash
WARNING: This will create a service account `argocd-manager` on the cluster referenced by context `kind-kind` with full cluster level privileges. Do you want to continue [y/N]? y
INFO[0020] ServiceAccount "argocd-manager" created in namespace "kube-system" 
INFO[0020] ClusterRole "argocd-manager-role" created    
INFO[0020] ClusterRoleBinding "argocd-manager-role-binding" created 
INFO[0025] Created bearer token secret for ServiceAccount "argocd-manager" 
FATA[0025] rpc error: code = Unknown desc = Get "https://127.0.0.1:32919/version?timeout=32s": dial tcp 127.0.0.1:32919: connect: connection refused
```

Para contornar esse erro execute o comando `kubectl get -n default endpoints`. A saída será algo parecido com isso:

```bash
NAME         ENDPOINTS         AGE
kubernetes   192.168.49.2:8443   103m
```

Agora copie o ip e porta que foi mostrado com a execução do comando anterior e altere somente o valor de endereço do server no seu arquivo `.kube/config`, como no exemplo abaixo onde o ip antigo foi comentado e o novo endereço foi configurado:

```yaml
apiVersion: v1
clusters:
- cluster:
    #server: https://127.0.0.1:32919
    server: 192.168.49.2:8443
  name: kind-kind

```


Após essa modificação execute novamente o comando para adicionar o cluster ao ArgoCD

```bash
argocd cluster add O_NOME_DO_SEU_CONTEXT
```

E desta vez a saída sem erro será parecida com isso:

```bash
WARNING: This will create a service account `argocd-manager` on the cluster referenced by context `kind-kind` with full cluster level privileges. Do you want to continue [y/N]? y
INFO[0001] ServiceAccount "argocd-manager" already exists in namespace "kube-system" 
INFO[0001] ClusterRole "argocd-manager-role" updated    
INFO[0001] ClusterRoleBinding "argocd-manager-role-binding" updated 
Cluster 'https://172.18.0.2:6443' added
```

&nbsp;

Pronto, nosso cluster foi adicionado ao ArgoCD.

Vamos confirmar se o nosso cluster foi adicionado ao ArgoCD:

```bash
argocd cluster list
```

A saída será algo parecido com isso:

```bash
SERVER                                                                    NAME                                   VERSION  STATUS   MESSAGE                                                  PROJECT
                 192.168.49.2:8443                                       minkube                               Unknown  Cluster has no applications and is not being monitored.  
https://kubernetes.default.svc                                            in-cluster                                      Unknown  Cluster has no applications and is not being monitored. 
```

&nbsp;

Na saída, temos o nosso cluster adicionado, e o cluster local, que é o `in-cluster`, que vem por padrão.

&nbsp;

Pronto, já temos onde a nossa aplicação vai ser implantada, agora vamos criar a nossa aplicação para o ArgoCD.

&nbsp;

## Criando a aplicação no ArgoCD

Agora que já temos o nosso cluster adicionado ao ArgoCD, vamos criar a nossa aplicação. Para isso, temos que ter um repositório Git com o nosso código, e o ArgoCD vai monitorar esse repositório e vai fazer o deploy da nossa aplicação sempre que tiver uma alteração.

### Criando a nossa app exemplo

Para o nosso exemplo, vamos utilizar um repo que criem no GitHub, e o código está disponível https://github.com/amarachris/Argocd/tree/main;

Eu criei esse repo somente para servir de exemplo para essa nossa primeira parte. O que temos nesse repo são somente quatro arquivos, um que define o nosso `Deployment`, outro que define o nosso `Service`, temos um que define um `ConfigMap` e outro que define um `Pod`.

O nosso `Deployment` é bem simples, ele cria um `Pod` com dois containers, um que é o `nginx` e outro que é o `nginx-exporter`, que é um container que vai expor as métricas do nginx para o Prometheus.

O nosso `Service` é bem simples também, ele expõe a porta `9113` do nosso `Pod`, que é a porta que o `nginx-exporter`.

Já o nosso `ConfigMap` é um `ConfigMap` que terá a configuração default do nginx, que é o `default.conf`.

```bash
argocd app create nginx-server --repo https://github.com/amarachris/Argocd.git --path . --dest-server https://192.168.49.2:8443 --dest-namespace default 
```
&nbsp;

Onde:
* `nginx-app` é o nome da nossa aplicação
* `repo` é o repo onde está o nosso código
* `path` é o caminho onde está o nosso código
* `dest-server` é o cluster onde queremos fazer o deploy
* `dest-namespace` é o namespace onde queremos fazer o deploy

Observação:
Problemas com conexão com minkube realizar o throubleshoot abaixo

```bash
rm /tmp/juju-*
minikube delete && minikube start --extra-config=kubeadm.ignore-preflight-errors=NumCPU --force --cpus 1
```
Vamos criar para monitoramento do nosso Cluster o Prometheus junto com o Grafana:

```bash
  helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
  helm repo add stable https://charts.helm.sh/stable
  helm repo update
  helm install prometheus prometheus-community/kube-prometheus-stack
  kubectl port-forward deployment/prometheus-grafana 3000
```
Login do Grafana assim que fazer o direcionamento para prota 3000, o acesso teria que ser dentro da instância:

username: admin
password: prom-operator
