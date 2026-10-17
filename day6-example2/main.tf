module "test" {
    source = "../day6-modules"
    ami_id = var.ami_id
    instance_type = var.instance_type
    subnet_id ="subnet-0b40a8759b4430056"
  }

