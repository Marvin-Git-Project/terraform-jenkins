variable "ebs_size" {
  description = "Taille du volume EBS en GB"
  type        = number
  default     = 10
}

variable "availability_zone" {
  description = "Zone de disponibilite AWS"
  type        = string
}
