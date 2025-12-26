data "template_file" "user_data" {
  for_each = var.vm_build
  template = file("${path.module}/config/cloud_init.tpl")
  vars = {
    hostname = each.key
  }
}

data "template_file" "network_config" {
  for_each = var.vm_build
  template = file("${path.module}/config/network_config.tpl")
  vars = {
    ipaddress = each.value.vm_ip_address
  }
}

module "libvirt_volume_os_image" {
  source       = "../../../modules/libvirt-volume-os-image"
  name_value   = "${var.image_name}-${var.cluster_name}-os-base.qcow2"
  pool_value   = var.libvirt_pool
  source_value = "${var.image_path}/${var.image_name}"
  format_value = "qcow2"
}

module "libvirt_volume_server_disk" {
  source               = "../../../modules/libvirt-volume-server-disk"
  for_each             = var.vm_build
  name_value           = "${each.key}-server-disk.qcow2"
  size_value           = each.value.disk_size
  pool_value           = var.libvirt_pool
  base_volume_id_value = module.libvirt_volume_os_image.ubunutu_base_id
}

module "libvirt_cloudinit_disk" {
  source               = "../../../modules/libvirt-cloudinit-disk"
  for_each             = var.vm_build
  name_value           = "${each.key}_commoninit.iso"
  user_data_value      = data.template_file.user_data[each.key].rendered
  network_config_value = data.template_file.network_config[each.key].rendered
  pool_value           = var.libvirt_pool
}

module "libvirt_domain" {
  source          = "../../../modules/libvirt-domain"
  for_each        = var.vm_build
  name_value      = each.key
  memory_value    = each.value.memory_amount
  vcpu_value      = each.value.cpu_count
  cloudinit_value = module.libvirt_cloudinit_disk[each.key].cloud_init_disk_id
  // cpu
  mode_value = "host-passthrough"
  // disk
  volume_id_value = module.libvirt_volume_server_disk[each.key].server_disk_id
  scsi_value      = "true"
  // network_interface
  bridge_value = "virbr0"
  // console
  type_value        = "pty"
  target_type_value = "serial"
  target_port_value = "0"
}
