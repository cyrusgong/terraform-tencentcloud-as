# Tencentcloud Auto Scaling Group

Module to create tencentcloud Auto Scaling Group

Auto Scaling Group：

Reference: https://www.tencentcloud.com/zh/document/product/377


## About the auto refresh trigger:

1. enable auto refresh trigger

Note: Trigger will be triggered the first time you set trigger_refresh to true, no matter the config change or not

```hcl
  trigger_refresh             = true
  rolling_update_batch_number = 2 # this should always less than or equal to running instance number
```

2. trigger refresh

After the trigger_refresh enabled, any change of config id or config version will trigger auto refresh

Mechanism: 

```hcl

# triggered by this key

as_config_trigger_key = format("%s_%s", var.as_config_id, data.tencentcloud_as_scaling_configs.as_config.configuration_list[0].version_number)

```

3. Setup a timeout for auto refresh, it is by default 20 minutes



## usage
```hcl
module "tat" {
  source = "../../modules/tat"
  name = "test-tat-command-ls"
  command = {
    username              = "root"
    content               = "#!/bin/bash\nls -la"
    description           = "ls command"
    command_type          = "SHELL"
    working_directory     = "/root"
    timeout               = 50
  }
}

module "as-config" {
  source = "../../modules/as-config"

  configuration_name = "test"

  tags               = { create: "terraform-config"}
  instance_name      = "as-instance"
  instance_types     = [ "S5.MEDIUM4" ]
  os_name            = "Ubuntu Server 22.04 LTS 64"
  enable_image_family = false
  image_id         = "img-487zeit5"
  //  image_family = "Ubuntu Server 24.04 LTS"

  enhanced_security_service = true
  enhanced_monitor_service = true
  enhanced_automation_tools_service = true

  system_disk_size   = 50
  system_disk_type = "CLOUD_BSSD"
  security_group_ids = [ "sg-0xia1k06" ]
}



module "as-group" {
  source = "../../modules/as-group"

  tags = { create : "terraform-group" }

  scaling_group_name = "ag-test"

  as_config_id      = module.as-config.as_config_id
  as_config_version = module.as-config.as_config_version

  vpc_id              = "vpc-fkbtycmt"
  subnet_ids = ["subnet-qaf6qdts", "subnet-ch8ibgg8"]
  as_max_size         = 5
  as_min_size = 0
  // If you set trigger_refresh to true, make sure as_desired_capacity > 0, because the first trigger will fail if no instance in the as group
  as_desired_capacity = 1

  replace_load_balancer_unhealthy = false
  enable_auto_scaling             = true

  trigger_refresh = true
  refresh_timeout = "5m"
  rolling_update_batch_number = 1 # this should always less than or equal to running instance number
  rolling_update_max_surge = 1 #

  hooks = {
    startup = {
      lifecycle_hook_name  = "startup"
      lifecycle_transition = "INSTANCE_LAUNCHING"
      lifecycle_command = {
        command_id = module.tat.command_id
      }
      lifecycle_transition_type = "EXTENSION"
    }
    shutdown = {
      lifecycle_hook_name  = "shutdown"
      lifecycle_transition = "INSTANCE_TERMINATING"
      lifecycle_command = {
        command_id = module.tat.command_id
      }
      lifecycle_transition_type = "NORMAL"
    }
  }

}

```
## Requirements

No requirements.

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_as-config"></a> [as-config](#module\_as-config) | ../../modules/as-config | n/a |
| <a name="module_as-group"></a> [as-group](#module\_as-group) | ../../modules/as-group | n/a |

## Resources

No resources.

## Inputs

No inputs.

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_config_id"></a> [config\_id](#output\_config\_id) | ID of AS config |
| <a name="output_group_id"></a> [group\_id](#output\_group\_id) | ID of AS group |
