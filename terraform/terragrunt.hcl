remote_state {
  backend = "s3"
  config = {
    bucket         = "openalt2019-state"
    key            = "terraform.tfstate"
    region         = get_env("AWS_DEFAULT_REGION", "eu-central-1")
    encrypt        = true
    dynamodb_table = "openalt2019-lock"
  }
}

terraform {
  # Load environment based Terraform variables from terraform.${ENVIRONMENT}.tfvars file.
  # ENVIRONMENT env variable should be set to one of the following values:
  # * 'dev' (development)
  # * 'stg' (staging)
  # * 'prod' (production)
  extra_arguments "per_environment_tfvars" {
    commands = get_terraform_commands_that_need_vars()

    optional_var_files = [
      "${get_terragrunt_dir()}/terraform.${get_env("ENVIRONMENT", "")}.tfvars"
    ]
  }

  # 'terragrunt validate' will do extensive code quality checking
  before_hook "validate_fhclfmt" {
    commands = ["validate"]
    execute  = ["terragrunt", "hclfmt"]
  }

  before_hook "validate_fmt" {
    commands = ["validate"]
    execute  = ["terragrunt", "fmt", "-recursive"]
  }
}
