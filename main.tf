provider "aws" {
    region = "us-east-1"  
}

resource "aws_instance" "TestInstance" {
    ami = "ami-0b6d9d3d33ba97d99"
    instance_type = "t3.micro"
    security_groups = [aws_security_group.TestSecurityGroup.name]
    root_block_device {
        volume_size = 30
        volume_type = "gp3"
        delete_on_termination = true
    }
    tags ={
        Name = "testAk-instance"
    }

    user_data = file("jenkins-server.sh")
    key_name = "Project1"
}

resource "aws_security_group" "TestSecurityGroup" {
    name        = "testAk-security-group"
    description = "Security group for testAk instance"

    ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

