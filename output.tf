#--------------------------------------------
# Launch Template Outputs
#--------------------------------------------
output "launch_template_id" {
  description = "Launch Template ID"
  value = aws_launch_template.gitlab-runner-launch-template.id
}
output "launch_template_default_version" {
  description = "Launch Template Latest Version"
  value = aws_launch_template.gitlab-runner-launch-template.default_version
}
#--------------------------------------------
# Autoscaling Outputs
#--------------------------------------------
output "autoscaling_group_id" {
  description = "Autoscaling Group ID"
  value = aws_autoscaling_group.gitlab-runner-asg.id 
}

output "autoscaling_group_name" {
  description = "Autoscaling Group Name"
  value = aws_autoscaling_group.gitlab-runner-asg.name 
}

output "autoscaling_group_arn" {
  description = "Autoscaling Group ARN"
  value = aws_autoscaling_group.gitlab-runner-asg.arn 
}
#--------------------------------------------
# Security Group Outputs
#--------------------------------------------
output "security_group_id" {
  description = "Security Group Id"
  value = aws_security_group.gitlab-runner-sg.name 
}