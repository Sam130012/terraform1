resource "aws_security_group" "allow_tls"{
    name = "mysg-1"
    vpc_id = aws_vpc.my_vpc.id
    dynamic "ingress"{
        for_each = [22,80]
        iterator = port
        content{
            from_port = port.value
            to_port = port.value
            protocol = "tcp"
            cidr_blocks = ["0.0.0.0/0"]

        }
    }
    egress{
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
        ipv6_cidr_blocks = ["::/0"]
    }
    tags = {
        name = "my-sg-1"

    }
}

resource "aws_launch_template" "mobile" {
  name                   = "mobile-template"
  image_id               = var.ami_id
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.allow_tls.id]
  user_data              = filebase64("/home/ubuntu/terraform1/mobile.sh")
}

resource "aws_launch_template" "fashion" {
  name                   = "fashion-template"
  image_id               = var.ami_id
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.allow_tls.id]
  user_data              = filebase64("/home/ubuntu/terraform1/fashion.sh")
}

resource "aws_launch_template" "grocery" {
  name                   = "grocery-template"
  image_id               = var.ami_id
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.allow_tls.id]
  user_data              = filebase64("/home/ubuntu/terraform1/grocery.sh")
}

resource "aws_autoscaling_group" "asgmobile" {
  desired_capacity    = 1
  max_size            = 1
  min_size            = 1
  vpc_zone_identifier = [aws_subnet.private_subnet[0].id]
  target_group_arns   = [aws_lb_target_group.mobile.arn]
  launch_template {
    id = aws_launch_template.mobile.id
  }
}


resource "aws_autoscaling_group" "asgfashion" {
  desired_capacity    = 1
  max_size            = 1
  min_size            = 1
  vpc_zone_identifier = [aws_subnet.private_subnet[0].id]
  target_group_arns   = [aws_lb_target_group.fashion.arn]

  launch_template {
    id = aws_launch_template.fashion.id
  }
}

resource "aws_autoscaling_group" "asggrocery" {
  desired_capacity    = 1
  max_size            = 1
  min_size            = 1
  vpc_zone_identifier = [aws_subnet.private_subnet[0].id]
  target_group_arns   = [aws_lb_target_group.grocery.arn]

  launch_template {
    id = aws_launch_template.grocery.id
  }
}
