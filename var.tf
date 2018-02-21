variable "container_cpu" {
  description = "The number of cpu units to reserve for the container. See https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task_definition_parameters.html"
  default = "256"
}

variable "container_memory" {
  description = "The number of MiB of memory to reserve for the container. See https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task_definition_parameters.html"
  default = "256"
}

variable "min_capacity" {
  description = "Minimum number of containers to run"
  default = 1
}

variable "max_capacity" {
  description = "Minimum number of containers to run"
  default = 3
}
