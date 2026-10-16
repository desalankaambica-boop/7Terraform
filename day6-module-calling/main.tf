module "nit" {
    source = "../day6-ec2 modules"
    ami = "ami-0d53cc9bd365ad65b"
    instance_type = "t3.micro"
    subnet_id ="subnet-0b40a8759b4430056"
    tags = {
    Name = "nit"
  }
    }
