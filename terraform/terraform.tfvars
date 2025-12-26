## VM Image Configuration
image_name   = "noble-server-cloudimg-amd64.img"
image_path   = "/data/homelab/iso"
libvirt_pool = "images"
cluster_name = "k8s3"

## VM Configuration
vm_build = {
  k8s3-vm1 = {
    vm_ip_address = "192.168.122.61/24"
    cpu_count     = 2
    memory_amount = 4096
    disk_size     = 21000000000
  },
  k8s3-vm2 = {
    vm_ip_address = "192.168.122.62/24"
    cpu_count     = 2
    memory_amount = 2048
    disk_size     = 21000000000
  },
  k8s3-vm3 = {
    vm_ip_address = "192.168.122.63/24"
    cpu_count     = 2
    memory_amount = 2048
    disk_size     = 21000000000
  }
}
