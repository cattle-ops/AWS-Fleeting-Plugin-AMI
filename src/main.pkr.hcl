data "amazon-ami" "amazon_linux" {
  filters = {
    # renovate: amiFilter=[{"Name":"owner-id","Values":["137112412989"]},{"Name":"name","Values":["al2023-ami-2023.*-kernel-6.1-x86_64"]},{"region":"eu-central-1"}]
    # currentImageName=al2023-ami-2023.8.20250915.0-kernel-6.12-x86_64
    image-id = "ami-090a27e0710d8ef71"
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
  temporary_security_group_source_public_ip = true # restricts incoming traffic to the machine the GitHub Action is running on
  vpc_id                                = var.vpc_id
  deprecate_at = local.deprecate_ami_at
  # TODO use `null` for snapshots
  ami_groups = null # ["all"] # make the AMI public
  run_tags = local.default_run_tags
  run_volume_tags = local.default_run_tags
  snapshot_tags = merge(local.created_resources_tags, {
    "Name" = "GitLab Runner Fleeting ${var.github_tag} - AMI"
  })

  tags = local.created_resources_tags

  # deregistration is done via a Lambda function, no user interaction needed
  deregistration_protection {
    enabled = true
    with_cooldown = false
  }
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
