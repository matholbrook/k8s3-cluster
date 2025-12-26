variable "vm_build" {
  description = "Map of VM configurations"
  type = map(object({
    vm_ip_address = string
    cpu_count     = number
    memory_amount = number
    disk_size     = number
  }))
}

variable "cluster_name" {
  description = "Name of the cluster"
  type        = string
}

variable "image_name" {
  description = "Name of the image used to build the VM"
  type        = string
}

variable "image_path" {
  description = "Path to the image file"
  type        = string
}

variable "libvirt_pool" {
  description = "Existing libvirt pool"
  type        = string
}
