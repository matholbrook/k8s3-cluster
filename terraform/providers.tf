terraform {
  required_version = "~> 1.14.3"

  required_providers {
    template = {
      source  = "hashicorp/template"
      version = "~> 2"
    }
    libvirt = {
      source  = "dmacvicar/libvirt"
      version = "~> 0.8.3"
    }
  }

  backend "local" {
    path = "/data/homelab/infrastructure/iac/tf-state/k8s3-cluster.tfstate"
  }
}

provider "libvirt" {
  uri = "qemu:///system"
}
