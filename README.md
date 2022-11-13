## Microservices with Docker Compose and NGINX Load Balancer
## Stacks 
    * Terraform
    * AWS
    * Python
    * Docker
    * NGINX
    * Nodejs

## STEPS TO REPRODUCE

I used terraform cloud workspaces so you have to edit the `onedot-autoscaling-terraform/production/provider.tf` accordingly. [a relative link](onedot-autoscaling-terraform/production/provider.tf)

```
cd onedot-autoscaling-terraform
cd production
terraform apply

```

### Directory structure
```
task
|-- app
|   |-- Dockerfile
|   |-- main.js
|   |-- package-lock.json
|   |-- package.json
|
|-- onedot-autoscaling-terraform
|   |-- moules
|   |-- production
|   |-- staging
|
|-- least-connected-lb
|   |-- nginx
|   |   |-- nginx.conf
|   |-- Dockerfile
|
|-- session-persist-lb
|   |-- nginx
|   |   |-- nginx.conf
|   |-- Dockerfile
|
|-- testing-lb
|   |-- testing-lb.py
|   
|-- upsteam-lb
|   |-- nginx
|   |   |-- nginx.conf
|   |-- Dockerfile
|
|-- weight-lb
|   |-- nginx
|   |   |-- nginx.conf
|   |-- Dockerfile
|
|-- docker-compose.yml

```

## CHARTS
Below are the architectural designs for the app optimized for high availability, scalability, security and fault tolerance.
![loadbalancing](./charts/loadbalancing.png?raw=true "loadbalancing") 
![autoscaling](./charts/autoscaling.png?raw=true "autoscaling") 
![networking](./charts/networking.png?raw=true "networking") 

## Overview
With just `terraform apply`, you would provision a VPC, Public and Private Subnets, 2 Security Group, 2 NAT Gateways, 2 Elastic IP, Route Tables and Route Table Associations, Internet Gateway, Application Load Balancer, AutoScaling Group, Cloudwatch Metric Alarms for Scaling. 
![networking](./charts/networking.png?raw=true "networking") 

## Microservices in EC2
I leverage launch template to deploy my application into EC2 instances. I used the sample nodejs app and configured NGINX Load Balancer. In my docker compose file, I spin up 2 instances of the app and then expose my load balancer to the host network to be accessible. Only the Load Balancer is accessible from the host network as seen in the chart below
![loadbalancing](./charts/loadbalancing.png?raw=true "loadbalancing") 

## Autoscaling
Because we want the whole application to be scalable, I also implemented autoscaling of the ec2 instances when CPU > 80% it scales up and when CPU < 5% it scales down. Provisioned everything using Terraform script
![autoscaling](./charts/autoscaling.png?raw=true "autoscaling") 

## Reusability
For reusability, I configured Terraform modules and also 2 environments. One for Prod and One for Stage
[a relative link](onedot-autoscaling-terraform/)


## Types of Load Balancing that was used in docker compose
I configured four different load balancing technique for different use case.

* Default Load Balancing
   Round Robin distributed the workload equally to available services
   [a relative link](upstream-lb/nginx/nginx.conf)
* Session Persist Load Balancing
    Mostly used for applications that store its states locally (not in a shared memory). This type of loadbalancing maps and persist every request of a particular session to a service. 
    [a relative link](session-persist-lb/nginx/nginx.conf)
* Weighted Load Balancing
    Distibutes workloads according to configurable weights. Mostly used when you have servers with different capacity size
    [a relative link](weight-lb/nginx/nginx.conf)
* Least Connected Load Balancing
    Distributes workload to the service with least number of connections.   Appropriate for incoming requests that have varying connection times and a set of servers that are relatively similar in terms of processing power and available resource.
    [a relative link](least-connected-lb/nginx/nginx.conf)

## Testing Load Balancing
I configured a Python Script which evidently shows that workloads are shared between the two app services. I would like to try this in a live demo, if hopefully I get selected for the next round.
[a relative link](testing-lb/testing-lb.py)


## Docker Image
My mission always has been a smaller docker size with no security vulnerabilities. We all know that big docker sizes takes longer time to start, and seeing how we want our application to be highly scalable, we would like our docker containers to start in less time and be able to handle the connections as soon as possible. 

I compared possible nodejs images, to see what suits best in this case scenario, and without a doubt the node:16.18.1-bullseye-slim was the most suitable images to use for our nodejs app. 

The node:alpine provides a much slimmer docker images, and lesser security vulnerability but I chose node:16.18.1-bullseye-slim because node:alphine is an unofficial nodejs image and we may experience performance issues, functional bugs, or potential application crashes. 
https://stackoverflow.com/questions/51871820/when-i-using-node-alpine-with-docker-it-does-not-work-properly 

The Nodejs team also states that Alphine based images are experimental and may not be consistent, we might not want that problem especially in production
I also compared node:16.18.1-bullseye-slim to node:lts-slim and node:slim

![docker-sec](./charts/docker-sec.jpeg?raw=true "docker-sec") 

From the above node:16.18.1-bullseye-slim and node:lts-slim are a clear winner. But lets compare their sizes 

![docker-image](./charts/docker-image.jpeg?raw=true "docker-image") 

So node:16.18.1-bullseye-slim has smaller size than node:lts-slim. 

Overall I concluded that the node:16.18.1-bullseye-slim is the perfect docker image for a nodejs application.
