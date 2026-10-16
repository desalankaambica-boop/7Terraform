variable "ami_id"{
default = ""
type = string
}
variable "instance_type"{
    default = ""
    type = string
}
variable "subnet_id"{
    default = ""
    type = string
}
variable "tags" {
    default = {}
    type = map(string)
  
}
