# Tencentcloud Auto Scaling Group Config

Module to create tencentcloud Auto Scaling Group Config

Auto Scaling Group Config:

Reference: https://www.tencentcloud.com/document/product/377/3579?lang=en&pg=

## usage
```hcl
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

```

To use image family, set 

```hcl
  enable_image_family = true
  image_family        = "family-1"

```

To create an image family, use

```terraform

resource "tencentcloud_image" "image_snap" {
  image_family      = "family-1"
  image_name        = "family-1-2"
#  snapshot_ids      = ["snap-nbp3xy1d", "snap-nvzu3dmh"] // from snapshot
  instance_id = "ins-pvc72xzg"  // from a instance
  force_poweroff    = true
  image_description = "create image with snapshot"
}

```

