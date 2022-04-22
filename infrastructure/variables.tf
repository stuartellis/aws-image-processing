variable "prefix" {
  default = "sje"
  type    = string
}

variable "image_function_name" {
  description = "Lambda function name"
  type        = string
  default     = "image_cleaner"
}

variable "handler" {
  description = "Lambda handler name"
  type        = string
  default     = "image_cleaner.handler"
}

variable "log_retention_days" {
  description = "Number of days to retain logs"
  type        = number
  default     = 14
}

variable "runtime" {
  description = "Lambda runtime"
  type        = string
  default     = "python3.9"
}
