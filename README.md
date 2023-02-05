# nodejs-vpc-terraform


This is the IaC part of the project where I had to build a highly available and fault taulerent architecture for a bussiness critical NodeJS application running SQL based database. In the provider.tf file, I have defined AWS as provider, eu-west-2[London] as region, and passed in my credentials file. In main.tf file, I have declared the following resources:

1) VPC
2) 2x public subnets
3) 2x private subnets
4) Internet Gateway
5) Elastic IP
6) NAT Gateway
7) Public route table
8) Route to IGW in public RT
9) Subnet associations with public RT
10) Private route table
11) Route to NAT gateway in private RT
12) Subnet associations with private RT
