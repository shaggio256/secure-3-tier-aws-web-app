# Secure 3-Tier AWS Web Application Architecture

## Overview

This project demonstrates a secure, highly available 3-tier web application
architecture built on Amazon Web Services (AWS).

The architecture separates the application into three layers:

1. Presentation Layer
2. Application Layer
3. Database Layer

## Architecture

Internet
   |
   v
Route 53
   |
   v
Application Load Balancer
   |
   v
Private EC2 Instances
   |
   v
Amazon RDS

## AWS Services

- Amazon VPC
- Public and Private Subnets
- Internet Gateway
- NAT Gateway
- Application Load Balancer
- Amazon EC2
- Amazon RDS
- Security Groups
- IAM
- Amazon CloudWatch

## Network Design

### Public Subnets

Public subnets contain resources that need controlled internet access.

- Application Load Balancer
- NAT Gateway

### Private Application Subnets

Application servers are placed in private subnets.

- EC2 instances
- No direct inbound internet access

### Private Database Subnets

The database layer is isolated from the internet.

- Amazon RDS
- Database access is allowed only from the application layer

## Security

Security Groups are used to control communication between layers.

Traffic flow:

Internet
→ Load Balancer
→ EC2
→ RDS

The database does not accept direct connections from the public internet.

## High Availability

The architecture is designed across multiple Availability Zones.

This provides improved availability and allows the application to continue
operating if one Availability Zone becomes unavailable.

## Monitoring

Amazon CloudWatch is used for monitoring:

- EC2 metrics
- Application performance
- Load Balancer metrics
- RDS metrics
- Logs and alarms

## Infrastructure as Code

Terraform is used to define and provision the AWS infrastructure.

Terraform configuration will be stored in:

`/terraform`

## Project Goals

This project demonstrates practical knowledge of:

- AWS networking
- VPC design
- Security Groups
- EC2
- Application Load Balancer
- Amazon RDS
- IAM
- CloudWatch
- Terraform
- High availability
- Cloud security
