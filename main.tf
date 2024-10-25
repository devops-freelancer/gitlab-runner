#------------------------------------------------------------
# Create the Security Group
#------------------------------------------------------------
resource "aws_security_group" "gitlab-runner-sg" {
  name        = "gitlab-runner-sg"
  description = "Allow SSH and HTTPs traffic"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
#----------------------------------------------------
# Create the Launch Template
#----------------------------------------------------
resource "aws_launch_template" "gitlab-runner-launch-template" {
  name = var.template_name
  description = "Gitlab Runner Launch Template"
  image_id = data.aws_ami.amzlinux2.id
  instance_type = var.instance_type
  vpc_security_group_ids = [aws_security_group.gitlab-runner-asg.id]
  user_data = filebase64("${path.module}/userdata.sh")
  ebs_optimized = true
  default_version = 1
  update_default_version = false
  iam_instance_profile {
    name = "test"
  }
  block_device_mappings {
    device_name = "/dev/sda1"
    ebs {
      volume_size = 100    
      delete_on_termination = true
      volume_type = "gp2" 
     }
  }
  monitoring {
    enabled = true
  }
  tag_specifications {
    resource_type = "instance"
    tags = var.common-tags
  }
}

#------------------------------------------------------------
# Create the Auto Scaling Group
#------------------------------------------------------------
resource "aws_autoscaling_group" "gitlab-runner-asg" {
  name               = "example-auto-scaling-group"
  availability_zones = ["us-east-1a", "us-east-1b"] 
  health_check_type  = "EC2"
  min_size = 1
  max_size = 1
  desired_capacity = 1
  
  launch_template {
    id         = aws_launch_template.gitlab-runner-launch-template.id
    version    =  aws_launch_template.gitlab-runner-launch-template.default_version
  }

  tag {
    key                 = "Owners"
    value               = "Web-Team"
    propagate_at_launch = true
  } 
  instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage = 50
    }
    triggers = [ /*"launch_template",*/ "desired_capacity" ] 
  }  
}
#---------------------------------------------
# Autoscaling Notifications SNS - Topic
#---------------------------------------------
resource "aws_sns_topic" "gitlab-runner-sns-topic" {
  name = "gitlab-runner_sns_topic"
}

#---------------------------------------------
# Autoscaling Notifications SNS - Subscription
#---------------------------------------------
resource "aws_sns_topic_subscription" "gitlab-runner-sns-topic-subscription" {
  topic_arn = aws_sns_topic.gitlab-runner-sns-topic.arn
  protocol  = "email"
  endpoint  = "inbox.devops@gmail.com"
}
#---------------------------------------------
# Create Autoscaling Notification 
#---------------------------------------------
resource "aws_autoscaling_notification" "gitlab-runner-notifications" {
  group_names = [aws_autoscaling_group.gitlab-runner-asg.id]
  notifications = [
    "autoscaling:EC2_INSTANCE_LAUNCH",
    "autoscaling:EC2_INSTANCE_TERMINATE",
    "autoscaling:EC2_INSTANCE_LAUNCH_ERROR",
    "autoscaling:EC2_INSTANCE_TERMINATE_ERROR",
  ]
  topic_arn = aws_sns_topic.gitlab-runner-sns-topic.arn 
}
