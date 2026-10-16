module "test" {
    source = "../day6-modules"
    ami_id = "ami-0d53cc9bd365ad65b"
    instance_type = "t3.micro"
    subnet_id ="subnet-0b40a8759b4430056"
  }

 