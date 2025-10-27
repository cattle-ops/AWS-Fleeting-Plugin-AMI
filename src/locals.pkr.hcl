locals {
  timestamp = formatdate("YYYY-MM-DD'T'hh-mm-ssZ", timestamp())
  deprecate_ami_at = formatdate("YYYY-MM-DD'T'hh:mm:ssZ", timeadd(timestamp(), "4320h")) # 180 days

  ami_name = "gitlab-runner-worker-with-fleeting-${local.timestamp}"

  default_run_tags = {
    "hlag:Application"        = "packer",
    "hlag:AppOwner"           = "itsales/GitHub",
    "hlag:Environment"        = "prod",
    "hlag:Service"            = "Github/OSS",
    "hlag:CostCenter"         = "615000",
    "hlag:ManagedBy"          = "itsales/GitHub",
    "hlag:DataClassification" = "Public",
    "hlag:ProcessesPII"       = "False",
    "hlag:KritisRelevant"     = "False",
    "hlag:ServiceAccessedBy"  = "Internal"
  }

  created_resources_tags = merge(local.default_run_tags, {
    "Name" = "GitLab Runner Fleeting ${var.github_tag}"
    "github:repository" = var.github_repository
    "github:commit-sha" = var.github_commit_sha
    "github:release-version" = var.github_tag
    "github:is-snapshot" = var.github_is_snapshot
  })
}
