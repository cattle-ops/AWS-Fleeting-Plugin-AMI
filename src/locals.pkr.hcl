locals {
  timestamp = formatdate("YYYY-MM-DD'T'HH-mm-ssZ", timestamp())
  ami_name  = "gitlab-runner-worker-with-fleeting-${local.timestamp}"
}
