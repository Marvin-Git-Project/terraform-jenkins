variable "sg_name" {
  description = "Nom du security group"
  type        = string
  default     = "jenkins-sg"
}

variable "ingress_rules" {
  description = "Liste des regles entrantes"
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
}

variable "egress_rules" {
  description = "Liste des regles sortantes"
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
}