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

output "config_id" {
  value = module.as-config.as_config_id
  description = "ID of AS config"
}

output "group_id" {
  value = module.as-group.as_group_id
  description = "ID of AS group"
}


