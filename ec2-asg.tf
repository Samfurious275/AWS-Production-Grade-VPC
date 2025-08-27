# User Data Script (to install simple web server)
resource "aws_launch_template" "web" {
  name          = "web-launch-template"
  image_id      = "ami-0abcdef1234567890" # Use latest Amazon Linux 2
  instance_type = var.instance_type
  key_name      = var.key_name
  vpc_security_group_ids = [aws_security_group.web.id]

  user_data = base64encode(<<-EOF
              #!/bin/bash
              yum update -y
              yum install -y httpd
              echo "<h1>My AWS Project - Server $(hostname)</h1>" > /var/www/html/index.html
              systemctl start httpd
              systemctl enable httpd
              EOF
  )

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "Web-Server"
    }
  }
}

# Auto Scaling Group
resource "aws_autoscaling_group" "web" {
  name                = "web-asg"
  vpc_zone_identifier = aws_subnet.private[*].id
  target_group_arns   = [aws_lb_target_group.main.arn]
  health_check_type   = "EC2"

  min_size         = 2
  max_size         = 4
  desired_capacity = 2

  launch_template {
    id      = aws_launch_template.web.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "Web-Server"
    propagate_at_launch = true
  }
}
