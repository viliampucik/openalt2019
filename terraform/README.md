# Terraform Example

Terraform and Terragrunt example for OpenAlt 2019

## Pre-Commit Hooks

Hooks that validate Terraform code and also update _README.md_ documentation before each code changing commit.

First of all install and configure pre-commit framework:

```bash
git init
cat <<EOF > .pre-commit-config.yaml
- repo: git://github.com/antonbabenko/pre-commit-terraform
  rev: v1.19.0
  hooks:
    - id: terraform_fmt
    - id: terraform_docs
EOF
pre-commit run -a
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
