resource "aws_instance" "name" {
  ami           = "ami-0d53cc9bd365ad65b"
  instance_type = "t3.micro"
  
  # Add this line with the ID of your custom subnet:
  subnet_id     = "subnet-00533cd83c7a4aee8" 

  tags = {
    Name = "Nit"
  }

 lifecycle {
    ignore_changes        = [tags]
    create_before_destroy = true
    prevent_destroy       = true
  }
}


