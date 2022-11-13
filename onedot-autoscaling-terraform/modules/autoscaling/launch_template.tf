# Launch template for the autoscaling group
resource "aws_launch_template" "onedot_launch" {
  name = "onedot-template-${var.environment}"

  instance_type = var.instance_type
  key_name  = var.key_name != null ? var.key_name : null
  image_id      = data.aws_ami.ubuntu.id
  

  vpc_security_group_ids = [var.sg_allow_8888]


  user_data = filebase64("${path.module}/script.sh")


   tag_specifications {
     resource_type = "instance"
     tags          = {
                key                = "ResourceName"
                value              = "${var.project}-asg" 
                propagate_at_launch = true
     }
   }

}

data "aws_ami" "ubuntu" {

    most_recent = true

    filter {
        name   = "name"
        values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
    }

    filter {
        name = "virtualization-type"
        values = ["hvm"]
    }

    owners = ["099720109477"]
}

