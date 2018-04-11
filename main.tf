  provider "aws" {
  access_key = “ "
  secret_key = “ "
  region = "us-east-1"
}
resource "aws_instance" "xwiki"{

  ami           = "ami-1853ac65"
  instance_type = "t2.micro"
  vpc_security_group_ids = [ "sg-994090d0"]
  key_name = "dock-terra-april10"

  connection {
    user = "ec2-user"
    type = "ssh"
    private_key = "${file("/root/terraform_old/terraformfile_ssh/dock-terra-april10.pem")}"
  }

  provisioner "remote-exec" {
    inline = [ 
    	       "sudo yum install -y docker wget",
               "sudo usermod -aG docker ec2-user",
		"sudo service docker restart",
	       "sudo curl -L https://github.com/docker/compose/releases/download/1.20.1/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose",
               "sudo chmod +x /usr/local/bin/docker-compose",
               "sudo wget -O docker-compose.yml https://raw.githubusercontent.com/xwiki-contrib/docker-xwiki/master/docker-compose-postgres.yml",
               "sudo service docker restart", 
    ]
  }


  provisioner "remote-exec" {
    inline = [ 
               "docker-compose up -d",
    ]
  }

}
