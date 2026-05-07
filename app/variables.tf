variable "instance_type" {
  description = "Taille de linstance EC2"
  type        = string
  default     = "t3.micro"
}

variable "instance_name" {
  description = "Tag Name de linstance EC2"
  type        = string
  default     = "jenkins-server"
}

variable "key_name" {
  description = "Nom de la paire de cles SSH"
  type        = string
  default     = "jenkins-key"
}

variable "ebs_size" {
  description = "Taille du volume EBS en GB"
  type        = number
  default     = 10
}

variable "sg_name" {
  description = "Nom du security group"
  type        = string
  default     = "jenkins-sg"
}