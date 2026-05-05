# GitHub Actions Workflow for Terraform Deployment

This document outlines a GitHub Actions workflow designed for automating Terraform deployments on AWS infrastructure.

## Overview

The workflow is triggered on pushes to the `terraform_check` branch and performs Terraform initialization and application using a custom Docker image.

## Workflow Configuration

```yaml
# Workflow name for identification in GitHub Actions
name: Terraform Deploy

# Trigger configuration: runs on push to terraform_check branch
on:
  push:
    branches:
      - terraform_check

# Define the jobs to run
jobs:
  terraform:
    # Run on the latest Ubuntu runner
    runs-on: ubuntu-latest

    steps:
      # Step 1: Checkout the repository code
      - name: Checkout Code
        uses: actions/checkout@v3

      # Step 2: Login to Docker Hub for image access
      # Note: Ensure DOCKER_USERNAME and DOCKER_PASSWORD secrets are set in GitHub
      # path to secrets: Settings > Secrets and variables > Actions
      - name: Login to DockerHub
        uses: docker/login-action@v3
        with:
          username: ${{ secrets.DOCKER_USERNAME }}
          password: ${{ secrets.DOCKER_PASSWORD }}

      # Step 3: Build the custom Docker image with Terraform
      - name: Build Docker Image
        run: docker build -t formycore/aws-terraform:latest .

      # Step 4: Push the built image to Docker Hub
      - name: Push Docker Image
        run: docker push formycore/aws-terraform:latest

      # Step 5: Execute Terraform commands inside Docker container
      - name: Run Terraform inside container
        run: |
          # Run Docker container with AWS credentials and workspace volume
          docker run --rm \
            -e AWS_ACCESS_KEY_ID=${{ secrets.AWS_ACCESS_KEY_ID }} \
            -e AWS_SECRET_ACCESS_KEY=${{ secrets.AWS_SECRET_ACCESS_KEY }} \
            -e AWS_DEFAULT_REGION=ap-south-1 \
            -v ${{ github.workspace }}:/app \
            formycore/aws-terraform:latest \
            bash -c "terraform init && terraform apply -auto-approve"
```

## Key Features

- **Automated Deployment**: Triggers on branch pushes for continuous deployment
- **AWS Integration**: Uses GitHub secrets for secure AWS credential management
- **Docker-based**: Runs Terraform in a containerized environment
- **Region Configuration**: Set to `ap-south-1` (Asia Pacific - Mumbai)

## Prerequisites

1. **GitHub Secrets**: Configure the following secrets in your repository:
   - `AWS_ACCESS_KEY_ID`: Your AWS access key
   - `AWS_SECRET_ACCESS_KEY`: Your AWS secret access key
   - `DOCKER_USERNAME`: Your Docker Hub username
   - `DOCKER_PASSWORD`: Your Docker Hub password or access token

2. **Docker Image**: The workflow will build and push the `formycore/aws-terraform:latest` image automatically

3. **Terraform Files**: Your Terraform configuration files should be in the repository root

## Security Notes

- AWS credentials are passed securely via GitHub secrets
- The workflow only runs on the specified branch to prevent accidental deployments
- Docker container is run with `--rm` flag for cleanup

## Usage

1. Push your Terraform code to the `terraform_check` branch
2. The workflow will automatically initialize and apply your infrastructure changes
3. Monitor the Actions tab for deployment status and logs