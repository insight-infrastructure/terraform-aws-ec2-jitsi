# terraform-aws-ec2-jitsi

[![open-issues](https://img.shields.io/github/issues-raw/robc-io/terraform-aws-ec2-jitsi?style=for-the-badge)](https://github.com/robc-io/terraform-aws-ec2-jitsi/issues)
[![open-pr](https://img.shields.io/github/issues-pr-raw/robc-io/terraform-aws-ec2-jitsi?style=for-the-badge)](https://github.com/robc-io/terraform-aws-ec2-jitsi/pulls)

## Features

This module deploys a Jitsi server on an ec2. Configuration is done with ansible. Specify an hostname and domain name to
get `A` records populated.

## Terraform Versions

For Terraform v0.12.0+

## Usage

```
module "this" {
  source = "github.com/robc-io/terraform-aws-ec2-jitsi"
  subnet_id = module.vpc.public_subnets[0]

  vpc_security_group_ids = [
  aws_security_group.this.id]

  public_key_path  = var.public_key_path
  private_key_path = var.private_key_path

  root_domain_name = var.root_domain_name
}
```
## Examples

- [defaults](https://github.com/robc-io/terraform-aws-ec2-jitsi/tree/master/examples/defaults)

## Known  Issues
No issue is creating limit on this module.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Providers

| Name | Version |
|------|---------|
| aws | n/a |
| random | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| create\_spot | Bool for spot pricing | `bool` | `true` | no |
| eip\_id | The elastic ip id to attach to active instance | `string` | `""` | no |
| environment | The environment | `string` | `""` | no |
| hostname | The hostname if creating dns record - hostname.example.com | `string` | `"jitsi"` | no |
| instance\_type | Instance type | `string` | `"t2.medium"` | no |
| key\_name | The key pair to import | `string` | `""` | no |
| name | The name for the label | `string` | `"prometheus"` | no |
| namespace | The namespace to deploy into | `string` | `"prod"` | no |
| network\_name | The network name, ie kusama / mainnet | `string` | `"main"` | no |
| owner | Owner of the infrastructure | `string` | `""` | no |
| playbook\_vars | Extra vars to include, can be hcl or json | `map(string)` | `{}` | no |
| private\_key\_path | The path to the private ssh key | `string` | n/a | yes |
| public\_key\_path | The path to the public ssh key | `string` | n/a | yes |
| root\_domain\_name | The root domain.... | `string` | `""` | no |
| root\_volume\_size | Root volume size | `string` | `8` | no |
| stage | The stage of the deployment | `string` | `"blue"` | no |
| subnet\_id | The id of the subnet | `string` | n/a | yes |
| vpc\_security\_group\_ids | List of security groups | `list(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| public\_ip | n/a |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Testing
This module has been packaged with terratest tests

To run them:

1. Install Go
2. Run `make test-init` from the root of this repo
3. Run `make test` again from root

## Authors

Module managed by [robc-io](github.com/robc-io)

## Credits

- [Anton Babenko](https://github.com/antonbabenko)

## License

Apache 2 Licensed. See LICENSE for full details.