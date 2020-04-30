# Micro Services App
Kubernetes Version of [https://github.com/nomanaadma/Micro-Services-App](https://github.com/nomanaadma/Micro-Services-App)

## Prerequisites

* [Docker](https://www.docker.com) - Containerization of App
* [Minikube](https://kubernetes.io/docs/setup/learning-environment/minikube/) - For running Kubernetes locally inside VM
* [Kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/) - The Kubernetes command-line tool
* [Skaffold](https://skaffold.dev/) - Local Kubernetes Development

### Deployment on GCP

###### Connect Repository to Travis CI 
<ul><li>

[https://docs.travis-ci.com/user/tutorial/#to-get-started-with-travis-ci-using-github](https://docs.travis-ci.com/user/tutorial/#to-get-started-with-travis-ci-using-github)</li>
</ul>

###### GCP Project Initialization
<ul>
<li>Create a Project</li>
<li>Select the Created Project</li>
<li>Enable Billing</li>
<li>Navigate to Kubernetes Engine from sidebar menu</li>
<li>Click Create Cluster</li>
<li>Select desired configuration for cluster and create it</li>
</ul>

###### Generating Service Account on GCP
<ul>
<li>Navigate to sidebar hover on "IAM & Admin" then select "Service Accounts" from sub menu</li>
<li>Fill the required data to create the service account. Make sure you select the Account Role as "Kubernetes Engine Admin"</li>
<li>Generate the json key of newly created account and save it somewhere in your local system</li>
</ul>

###### Service Account Encryption for Travic CI
To encrypt the service account we need to install travis cli which requires ruby to be installed locally or alternatively we can use the ruby docker image because installing ruby might be a pain so we are going to choose the second strategy

``` shell
docker run -it -v $(pwd):/app ruby:2.3 sh
```

Note: pwd is the directory where your service-account.json lies it can be anywhere so make sure you open the terminal in that directory

``` shell
gem install travis
```
``` shell
travis login --com
```

it will ask for you github credentials

``` shell
travis encrypt-file service-account.json -r nomanaadma/Micro-Services-App/master/README.md --com
```
it will generate the encrypted file "service-account.json.enc" out of service-account.json.
Copy the encrypted file and paste it in your project's working directory and commit it to github.

###### Keys in Travis
<ul>
<li><p>Open up Travis dashboard and find your app</p></li>
<li><p>Click More Options, and select Settings</p></li>
<li><p>Scroll to Environment Variables</p></li>
<li><p>Add DOCKER_USERNAME and set your docker id</p></li>
<li><p>Add DOCKER_PASSWORD and set your docker password</p></li>
</ul>

###### Generating Secret in k8s cluster for Postgres Password in GCP
<ul>
<li><p>Select your project from the panel</p></li>
<li><p>On the navbar click the icon of shell to activate the cloud shell</p></li>
<li><p>Run the below commands</p></li>
</ul>

``` shell 
gcloud config set project <your project name>
gcloud config set compute/zone <your zone name>
gcloud container clusters get-credentials <your cluster name>
kubectl create secret generic pgpassword --from-literal PGPASSWORD=<yourpassword>
```
now the secret must have been created to confirm navigate to Configuration from sidebar and see if there's a pgpassword secret in the table list

###### Installing Helm v3 and nginx ingress in GKE Cluster
In the cmd of GCP run the following commands
``` shell 
curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 > get_helm.sh
chmod 700 get_helm.sh
./get_helm.sh
helm repo add stable https://kubernetes-charts.storage.googleapis.com/
helm install my-nginx stable/nginx-ingress --set rbac.create=true 
```

## Screenshots
See the screenshots folder for detailed instructions.