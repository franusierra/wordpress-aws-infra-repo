variable "db_user" {
  type = string
}
variable "db_password" {
  type = string
}
variable "db_name" {
  type = string
}
variable "image" {
  type = string
}
variable "vpc_id"{
  type = string
}
variable "subnet_id"{
  type    = list(string)
}