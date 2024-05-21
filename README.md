# Running an Nginx Application on Docker and Kubernetes


## Part 1: Running the Nginx Application on Docker

### Prepare Your Project Directory

- Create a directory for your project and place your index.html file in this directory.

```bash
mkdir kubernetes-nginx
cd kubernetes-nginx
```

- Create the `index.html` file for your application. [My index file for this project](./index.html) 

```bash
touch index.html
vim index.html # to go inside the file and edit. 

```

- Create a `Dockerfile` to build your Docker Image

```bash
touch Dockerfile
vim Dockerfile
```
- Copy and Paste following; 

```yml
# Use the official Nginx image from Docker Hub
FROM nginx:latest

# Copy your current directory files to the Nginx HTML directory
COPY . /usr/share/nginx/html

# Expose port 80 to the outside world
EXPOSE 80
```

- Copy source code to Ubuntu; In this case i will just copy the gif image to the app folder; 

-  SSH into Ubuntu server via CLI of your computer (I have windows so: Powersell)

```powershell
ssh ubuntu@hostname
```
- After successfully connect to the ubuntu server edit following cmd; 

```powershell
scp "FILE PATH OF YOUR APP" ubuntu-name@hostname: <<path to your app file in the nginx server>>
```

### Docker Image 

- Build your Docker image using the Dockerfile.

```sh
docker build -t <<image-name>> . # in this case image name is kubesinem
```

### Run the Docker Container

```sh
docker run -d -p 8080:80 --name <<nameofyourcontainer>> <<image-name>>
```

## Part 2: Running the Nginx Application on Kubernetes

### Ensure Minikube is Running

- For this project we need minikube installed on our ubuntu server. 
- If not installed -> [Click Here](https://minikube.sigs.k8s.io/docs/start/)

- Start Minikube if it's not already running.

```sh
minikube start
```

- Set Up Minikube Docker Environment:
 - Configure your shell to use Minikube's Docker daemon.

```sh
eval $(minikube docker-env)
```

### Create Kubernetes Deployment and Service YAML File

- Create a yaml file and give a name with the following content: [In this Project it called:](./nginx-deployment.yml)

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
spec:
  replicas: 1
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: <<your image name>>
        imagePullPolicy: Never  # Ensure Kubernetes uses the local image
        ports:
        - containerPort: 80
---
apiVersion: v1
kind: Service
metadata:
  name: nginx-service
spec:
  selector:
    app: nginx
  ports:
    - protocol: TCP
      port: 80
      targetPort: 80
      nodePort: 30080  # Specify a NodePort
  type: NodePort

```

### Apply the Kubernetes Configuration:

- Apply the deployment and service configuration.

```sh
kubectl apply -f nginx-deployment.yaml
```

### Get Minikube IP Address 

```sh
minikube ip
```

### Access the Application via NodePort:
- 
Open your web browser and navigate to http://<minikube-ip>:30080, replacing <minikube-ip> with the IP address obtained from the minikube ip command.


⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️


## Alternative: Using Port Forwarding
- If you `cannot access` the application via Minikube's NodePort, use kubectl port-forward to forward a local port to the Nginx service port.

- Port Forward the Service:
- Use the kubectl port-forward command to forward a port from your local machine to the Nginx service:

```sh
kubectl port-forward service/nginx-service 8080:80

```


### Access the Application via Port Forwarding:
Open your web browser and navigate to http://localhost:8080.



# SUMMARY
- Docker Steps:

1. Create project directory and index.html.
2. Create a Dockerfile.
3. Build the Docker image.
4. Run the Docker container.
5. Access the application on http://localhost:8080.

- Kubernetes Steps:

1. Start Minikube and configure the Docker environment.
2. Build the Docker image locally.
3. Create and apply Kubernetes deployment and service YAML.
4. Retrieve Minikube IP and access the application on http://<minikube-ip>:30080.

5. Port Forwarding (if needed):Use kubectl port-forward to forward a local port to the Nginx service port.
6. Access the application on http://localhost:8080.


![](./MY-FRIENDS.gif)


