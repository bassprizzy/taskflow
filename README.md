# TaskFlow — Cloud-Native Task Management Application

A containerized task management application deployed using Docker, Docker Compose, AWS, and Terraform.

TaskFlow demonstrates my practical experience in DevOps engineering, cloud infrastructure provisioning, containerization, CI/CD automation, and application deployment.

The project brings together a React frontend, Node.js backend, and PostgreSQL database, with infrastructure provisioned on AWS using Terraform.

## Project Overview

TaskFlow is a web-based task management application that allows users to manage their tasks through a simple interface.

The project focuses on implementing DevOps practices throughout the application lifecycle, from local development and containerization to infrastructure as code, automated testing, and cloud deployment.

### Key Features

- Create and manage tasks.
- Mark tasks as completed.
- Delete tasks.
- React-based frontend served using Nginx.
- Node.js backend exposing REST API endpoints.
- PostgreSQL database for persistent task storage.
- Docker-based application containerization.
- Docker Compose for managing application services.
- Terraform for AWS infrastructure provisioning.
- GitHub Actions for continuous integration.
- AWS EC2 deployment.
- Amazon RDS for managed PostgreSQL database hosting.
- Health checks for application services.

## Technology Stack

| Category | Technologies |
|---|---|
| Frontend | React, Vite, Nginx |
| Backend | Node.js, Express.js |
| Database | PostgreSQL |
| Containerization | Docker |
| Container Orchestration | Docker Compose |
| Cloud Platform | Amazon Web Services (AWS) |
| Infrastructure as Code | Terraform |
| CI/CD | GitHub Actions |
| Version Control | Git, GitHub |
| Operating System | Ubuntu Linux |
| Web Server | Nginx |

## Architecture

The application follows a three-tier architecture.

```text
                    USER
                      |
                      v
               HTTP / HTTPS
                      |
                      v
              +----------------+
              |    Frontend    |
              | React + Nginx  |
              |    Port 80     |
              +----------------+
                      |
                      v
              +----------------+
              |    Backend     |
              | Node.js / API  |
              |   Port 5000    |
              +----------------+
                      |
                      v
              +----------------+
              |   PostgreSQL   |
              |    Database    |
              +----------------+
                      |
                      v
                Persistent Data
```

### AWS Infrastructure

The production infrastructure is provisioned using Terraform.

```text
                         AWS CLOUD
                             |
                             v
                      +-------------+
                      |     VPC     |
                      +-------------+
                             |
              +--------------+--------------+
              |                             |
              v                             v
      +----------------+           +----------------+
      |  Public Subnet |           | Private Subnets|
      |                |           |                |
      |   EC2 Instance |           | Amazon RDS     |
      |   TaskFlow App |---------->| PostgreSQL     |
      +----------------+           +----------------+
              |
              v
       Internet Gateway
              |
              v
           Internet
```

The architecture uses a VPC, public and private subnets, security groups, an internet gateway, an EC2 instance, and an Amazon RDS PostgreSQL database.

Database access should be restricted to authorized application resources rather than exposed directly to the public internet.

## Project Structure

```text
taskflow/
├── .github/
│   └── workflows/
│       └── ci.yml
│
├── backend/
│   ├── Dockerfile
│   ├── .env.example
│   └── init.sql
│
├── frontend/
│   ├── Dockerfile
│   ├── nginx/
│   │   └── default.conf
│   └── src/
│       └── App.jsx
│
├── Terraform/
│   ├── main.tf
│   ├── provider.tf
│   ├── variables.tf
│   ├── outputs.tf
│   └── .terraform.lock.hcl
│
├── docker-compose.yml
├── docker-compose.prod.yml
└── README.md
```

## Running the Application Locally

### Prerequisites

Install the following tools:

- Git
- Docker
- Docker Compose
- Terraform (for infrastructure validation and provisioning)
- AWS CLI (for AWS operations)

### 1. Clone the Repository

```bash
git clone https://github.com/bassprizzy/taskflow.git
```

Navigate into the project directory:

```bash
cd taskflow
```

### 2. Configure Environment Variables

Create your local environment file from the example:

```bash
cp backend/.env.example backend/.env
```

Open the environment file:

```bash
nano backend/.env
```

Configure the required database environment variables.

For the local Docker Compose setup, the database host should be the PostgreSQL service name defined in Docker Compose.

Example:

```env
DB_USER=postgres
DB_PASSWORD=replace_with_a_secure_password
DB_NAME=taskflow
DB_HOST=postgres
DB_PORT=5432
```

Use the actual environment variable names required by the application.

**Security:** Never commit `.env` files, database passwords, AWS credentials, private keys, or other secrets to GitHub.

### 3. Build and Start the Application

Run:

```bash
docker compose --env-file backend/.env up --build -d
```

This builds and starts the application services.

### 4. Check Container Status

```bash
docker compose --env-file backend/.env ps
```

Check the application logs:

```bash
docker compose --env-file backend/.env logs
```

To inspect backend logs:

```bash
docker compose --env-file backend/.env logs backend
```

### 5. Access the Application

When running locally with the supplied Docker Compose configuration:

| Service | Address |
|---|---|
| Frontend | http://localhost:3000 |
| Backend | http://localhost:5000 |
| Tasks API | http://localhost:5000/tasks |

The PostgreSQL database is available to the other application services through the Docker Compose network.

### 6. Stop the Application

```bash
docker compose --env-file backend/.env down
```

To remove the local database volume as well, use:

```bash
docker compose --env-file backend/.env down -v
```

**Warning:** Removing the volume deletes the database data stored in that volume.

## Production Deployment

The application includes a production Docker Compose configuration.

The production deployment uses:

- Docker images for the frontend and backend.
- Nginx to serve the frontend.
- Docker Compose to manage application containers.
- AWS EC2 to host the application.
- Amazon RDS for PostgreSQL.
- Environment variables for application configuration.

### Production Deployment Commands

After configuring the production environment and confirming that the server has the required files:

```bash
sudo docker compose -f docker-compose.prod.yml config --quiet
```

Build and start the services:

```bash
sudo docker compose -f docker-compose.prod.yml up --build -d
```

Check service status:

```bash
sudo docker compose -f docker-compose.prod.yml ps
```

View logs:

```bash
sudo docker compose -f docker-compose.prod.yml logs
```

Test the frontend locally on the server:

```bash
curl -I http://localhost/
```

Test the tasks API:

```bash
curl http://localhost/tasks
```

The application has been tested on AWS EC2, and the backend has successfully retrieved task records from Amazon RDS PostgreSQL.

Actual deployment availability depends on the AWS instance state, network configuration, and security group rules.

## Infrastructure as Code with Terraform

Terraform manages the AWS infrastructure required for TaskFlow.

### Infrastructure Components

- AWS VPC.
- Public and private subnets.
- Internet gateway.
- Public route table and route association.
- EC2 security group.
- RDS security group.
- EC2 instance.
- Amazon RDS PostgreSQL instance.
- Database subnet group.
- Security group ingress and egress rules.

### Validate Terraform Configuration

Navigate to the Terraform directory:

```bash
cd Terraform
```

Format the configuration:

```bash
terraform fmt -recursive
```

Initialize Terraform:

```bash
terraform init
```

Validate the configuration:

```bash
terraform validate
```

Review the proposed infrastructure changes:

```bash
terraform plan
```

**Important:** Review the plan carefully before applying changes. Terraform can create, modify, or destroy AWS resources that may incur charges.

Do not commit Terraform state files, credentials, or sensitive variable files to the repository.

## Continuous Integration with GitHub Actions

TaskFlow uses GitHub Actions to automate important validation and testing tasks.

The workflow is defined in:

`.github/workflows/ci.yml`

### CI Pipeline

The pipeline contains two jobs.

**1. Terraform Validation**

- Checks Terraform formatting.
- Initializes Terraform without configuring a remote backend.
- Validates the Terraform configuration.

**2. Application Build and Test**

- Checks out the repository.
- Creates a CI environment file from the example.
- Builds the Docker images.
- Starts the application services.
- Checks container status.
- Waits for the backend to become available.
- Tests the backend API.
- Tests the tasks API.
- Tests the frontend.
- Collects container logs when tests fail.
- Stops the application after testing.

The workflow runs on the configured `main` branch push and pull request events.

The project has successfully passed both Terraform validation and application build/test checks in GitHub Actions.

## Security Considerations

Security is an important part of the deployment.

The project uses or should maintain the following practices:

- Restrict SSH access to trusted IP addresses.
- Avoid exposing PostgreSQL directly to the internet.
- Restrict database access to authorized application resources.
- Keep credentials outside source control.
- Use environment variables for sensitive configuration.
- Use restrictive file permissions for production environment files.
- Review AWS security group rules regularly.
- Use HTTPS for public production access.
- Store Terraform state securely when introducing a remote backend.

Production security settings should be reviewed before exposing the application to public users.

## Challenges and Lessons Learned

During development and deployment, I worked through several practical DevOps challenges.

### Docker Networking

Resolved service communication and port-binding issues while deploying the application with Docker Compose.

### Linux Server Administration

Worked with Ubuntu Linux, SSH authentication, file permissions, Docker commands, and server troubleshooting.

### AWS Networking

Configured and investigated AWS VPC networking, public and private subnets, security groups, EC2 access, and database connectivity.

### Infrastructure as Code

Used Terraform to define and validate AWS infrastructure and reviewed infrastructure plans before applying changes.

### CI/CD Troubleshooting

Debugged GitHub Actions workflow syntax, YAML indentation, workflow execution, and required status checks.

### Application Deployment

Built and deployed the frontend and backend as containers and verified that the backend could retrieve task records from Amazon RDS PostgreSQL.

These experiences strengthened my understanding of the relationship between application development, cloud infrastructure, automation, and production troubleshooting.

## Future Improvements

Potential improvements include:

- Automated deployment after successful CI checks.
- Terraform remote state management with locking.
- HTTPS configuration with automated certificate renewal.
- Domain name integration.
- Centralized application logging and monitoring.
- AWS CloudWatch alarms and dashboards.
- Container image vulnerability scanning.
- Automated backups and disaster recovery testing.
- Improved secret management.
- Infrastructure cost optimization.
- Automated rollback strategies.

## What This Project Demonstrates

Through TaskFlow, I have developed practical experience in:

- Containerizing applications with Docker.
- Managing multi-container applications with Docker Compose.
- Provisioning cloud infrastructure using Terraform.
- Deploying applications on AWS EC2.
- Connecting application services to Amazon RDS PostgreSQL.
- Configuring Linux servers and SSH access.
- Implementing CI pipelines with GitHub Actions.
- Troubleshooting deployment and networking problems.
- Using Git and GitHub for collaborative development workflows.
- Validating infrastructure changes before deployment.

## Author

**Bassey Prince Emekan**

Aspiring DevOps / Cloud Engineer

GitHub: https://github.com/bassprizzy

LinkedIn: https://www.linkedin.com/in/prince-emekan-520051210

---

If you are interested in DevOps, cloud infrastructure, or automation, feel free to explore the repository.

**Repository:** https://github.com/bassprizzy/taskflow
