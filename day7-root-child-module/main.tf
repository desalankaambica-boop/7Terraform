module "network" {
    source = "./modules/network"
    vpc_cidr = "10.0.0.0/24"
    subnet_cidr = "10.0.0.0/24"
  
}

module "compute" {
  source        = "./modules/compute"
  instance_type = var.instance_type
  subnet_id     = "subnet-0b40a8759b4430056"
  
  # This line sends the AMI value into the child module!
  ami           = var.ami 
}