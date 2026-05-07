variable "instance_type" {
  description = "Taille de linstance EC2 (ex: t2.micro)"
  type        = string
  default     = "t2.micro"
}

variable "instance_name" {
  description = "Tag Name de linstance EC2"
  type        = string
  default     = "jenkins-server"
}

variable "key_name" {
  description = "Nom de la paire de cles SSH"
  type        = string
}

variable "sg_id" {
  description = "ID du security group a attacher"
  type        = string
}

variable "ebs_id" {
  description = "ID du volume EBS a attacher"
  type        = string
}

variable "user_data" {
  description = "Script a executer au demarrage de lEC2"
  type        = string
  default     = ""
}
