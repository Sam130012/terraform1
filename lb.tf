resource "aws_lb" "newload"{
    name = "mylb"
    internal = "false"
    load_balancer_type = "application"
    security_groups = [aws_security_group.allow_tls.id]
    subnets = [aws_subnet.public_subnet[0].id, aws_subnet.public_subnet[1].id]
    enable_deletion_protection = false
    drop_invalid_header_fields = false
    idle_timeout = 60
}

resource "aws_lb_target_group" "fashion"{
    name = "fashiontg"
    port = 80
    protocol = "HTTP"
    vpc_id = aws_vpc.my_vpc.id
    health_check {
        path = "/"
        port = "80"
        protocol = "HTTP"
    }
}

resource "aws_lb_target_group" "mobile"{
    name = "mobiletg"
    port = 80
    protocol = "HTTP"
    vpc_id = aws_vpc.my_vpc.id
    health_check{
        path = "/mobile/"
        port = 80
        protocol = "HTTP"
    }
}

resource "aws_lb_target_group" "grocery"{
    name = "grocerytg"
    port = 80
    protocol = "HTTP"
    vpc_id = aws_vpc.my_vpc.id
    health_check{
        path = "/grocery/"
        port = 80
        protocol = "HTTP"
    }
}

resource "aws_lb_listener" "http"{
    load_balancer_arn = aws_lb.newload.arn
    port = "80"
    protocol = "HTTP"
    default_action{
        type = "forward"
        target_group_arn = aws_lb_target_group.fashion.arn
    }


}

resource "aws_lb_listener_rule" "mobileapp"{
  listener_arn = aws_lb_listener.http.arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.mobile.arn
  }

  condition {
    path_pattern {
      values = ["/mobile*"]
    }
  }
}

resource "aws_lb_listener_rule" "groceryappp"{
    listener_arn = aws_lb_listener.http.arn
    priority = 101
    action{
        type = "forward"
        target_group_arn = aws_lb_target_group.grocery.arn
    }
    condition{
        path_pattern{
            values = ["/grocery*"]
        }
    }
}
