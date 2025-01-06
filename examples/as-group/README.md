# Tencentcloud Auto Scaling Group

Module to create tencentcloud Auto Scaling Group

Auto Scaling Group:

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

```hcl
  refresh_timeout = "5m"
```


## usage
```hcl
module "as-group" {
  source = "../../modules/as-group"

  tags = { create : "terraform" }

  scaling_group_name = "ag-test"

  as_config_id      = "asc-8n5nxac7"
  as_config_version = 1

  vpc_id              = "vpc-fkbtycmtno"
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
        command_id = "cmd-9punekiv"
      }
      lifecycle_transition_type = "EXTENSION"
    }
    shutdown = {
      lifecycle_hook_name  = "shutdown"
      lifecycle_transition = "INSTANCE_TERMINATING"
      lifecycle_command = {
        command_id = "cmd-4oplyrwp"
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
| <a name="module_as-group"></a> [as-group](#module\_as-group) | ../../modules/as-group | n/a |

## Resources

No resources.

## Inputs

No inputs.

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_group_id"></a> [group\_id](#output\_group\_id) | ID of AS group |
