
module "as-config" {
  source = "../../modules/as-config"

  configuration_name = "test"

  tags               = { create: "terraform"}
  instance_name      = "as-instance"
  instance_types     = [ "S5.MEDIUM4" ]
  os_name            = "Ubuntu Server 22.04 LTS 64"
  enable_image_family = false
  image_id         = "img-487zeit5"
//  image_family = "business-daily-update"

  enhanced_security_service = true
  enhanced_monitor_service = true
  enhanced_automation_tools_service = true

  system_disk_size   = 50
  system_disk_type = "CLOUD_BSSD"
  security_group_ids = [ "sg-0xia1k06" ]
}

output "config_id" {
  value = module.as-config.as_config_id
  description = "ID of AS config"
}