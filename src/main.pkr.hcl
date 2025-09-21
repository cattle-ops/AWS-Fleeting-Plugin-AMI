data "amazon-ami" "amazon_linux" {
  filters = {
    # renovate: amiFilter=[{"Name":"owner-id","Values":["137112412989"]},{"Name":"name","Values":["al2023-ami-2023.*-kernel-6.1-x86_64"]},{"region":"eu-central-1"}]
    # currentImageName=al2023-ami-2023.8.20250808.1-kernel-6.1-x86_64
    image-id = "ami-05a2d2d0a1020fecd"
  }

  owners = ["137112412989"] # Amazon
}

source "amazon-ebs" "instance" {
  ami_description                       = "Amazon Linux 2023 for GitLab Runner Workers with Docker installed (${local.timestamp})"
  ami_name                              = local.ami_name
  instance_type                         = "t3.micro"
  region                                = var.aws_region
  source_ami                            = data.amazon-ami.amazon_linux.id
  ssh_username                          = "ec2-user"
  subnet_id                             = var.subnet_id
  temporary_security_group_source_cidrs = var.ingress_cidrs
  vpc_id                                = var.vpc_id
}

build {
  sources = ["source.amazon-ebs.instance"]

  # copy files to EC2 instance
  provisioner "file" {
    destination = "/tmp/scripts"
    source      = "src/scripts"
  }

  # run the setup script on the EC2 instance
  provisioner "shell" {
    inline = ["/tmp/scripts/setup_instance.sh"]
  }
}
