
resource "aws_security_group" "web" {
    name = "companynews"
    description = "Security group for Application/Web Server"

    # SSH access from anywhere
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    # HTTP access from anywhere
    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_elb" "web" {
  name = "companynews"

  availability_zones = [
    "${concat(var.region, "a")}",
    "${concat(var.region, "b")}"
  ]

  listener {
    instance_port = 80
    instance_protocol = "http"
    lb_port = 80
    lb_protocol = "http"
  }
}
output "elb" {
    value = "${aws_elb.web.dns_name}"
}

resource "aws_launch_configuration" "web" {
  name = "companynews"
  image_id = "${lookup(var.web_ami, var.region)}"
  instance_type = "${var.web_instance_type}"
  key_name = "${var.web_key_name}"
  security_groups = [ "${aws_security_group.web.name}"]
}

resource "aws_autoscaling_group" "web" {
  name = "companynews"
  availability_zones = [
    "${concat(var.region, "a")}",
    "${concat(var.region, "b")}"
  ]
  max_size = "${var.web_max_instances}"
  min_size = "${var.web_min_instances}"
  health_check_grace_period = 300
  health_check_type = "ELB"
  desired_capacity = 1
  launch_configuration = "${aws_launch_configuration.web.name}"
  load_balancers = ["${aws_elb.web.name}"]
  force_delete = true
}
