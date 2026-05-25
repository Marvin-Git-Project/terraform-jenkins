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
  default     = 50
}

variable "sg_name" {
  description = "Nom du security group"
  type        = string
  default     = "jenkins-sg"
}

variable "ingress_rules" {
  description = "Regles entrantes du security group"
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = [
    { from_port = 22,   to_port = 22,   protocol = "tcp", cidr_blocks = ["0.0.0.0/0"] },
    { from_port = 80,   to_port = 80,   protocol = "tcp", cidr_blocks = ["0.0.0.0/0"] },
    { from_port = 443,  to_port = 443,  protocol = "tcp", cidr_blocks = ["0.0.0.0/0"] },
    { from_port = 8080, to_port = 8080, protocol = "tcp", cidr_blocks = ["0.0.0.0/0"] }
  ]
}

variable "egress_rules" {
  description = "Regles sortantes du security group"
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = [
    { from_port = 0, to_port = 0, protocol = "-1", cidr_blocks = ["0.0.0.0/0"] }
  ]
}