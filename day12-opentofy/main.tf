resource "aws_instance" "name" {
    ami = "ami-0c230065b91270bc6"
    instance_type = "t3.micro"
    tags = {
        Name = "dev-2"
    }
  
}

