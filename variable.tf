variable "template_name" {
type = string
default = "gitlab-runner-launch-template"
description = "template name"    
}

variable "instance_type" {
type = string
default = "c6g.2xlarge"
description = "instance type "    
}

variable "common-tags" {
  type = map(string)
  description = "instance type"   
  default = {
    Name           = ""
    Environment    = ""
    DeploymentType = ""
    ProjectId      = ""
  } 
  }
