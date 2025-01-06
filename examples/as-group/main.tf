
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
        command_id = "cmd-ofk1ddjf"
      }
      lifecycle_transition_type = "EXTENSION"
    }
    shutdown = {
      lifecycle_hook_name  = "shutdown"
      lifecycle_transition = "INSTANCE_TERMINATING"
      lifecycle_command = {
        command_id = "cmd-ofk1ddjf"
      }
      lifecycle_transition_type = "NORMAL"
    }
  }

}

output "group_id" {
  value = module.as-group.as_group_id
  description = "ID of AS group"
}