#cloud-config
hostname: ${hostname}

#vm package update
package_update: true
package_upgrade: true
packages:
  - curl
  - wget
  - jq
  - openvswitch-switch

# user setup
users:
- name: mat
  gecos: Test VM user
  groups: users,admin,wheel,sudo
  sudo: ALL=(ALL) NOPASSWD:ALL
  shell: /bin/bash
  lock_passwd: false
  ssh_authorized_keys:
    - "ecdsa-sha2-nistp521 AAAAE2VjZHNhLXNoYTItbmlzdHA1MjEAAAAIbmlzdHA1MjEAAACFBACq9Y95hvUWFz8s6rQ2Os++9Z3jRAEwEdKesJ0CN7srt+51jpX6QjQI7JyKNVj03EjpHlgxo+A3IZX4CLLYkUsBJAHprgP8eLKJ0D5wnPvmO0a+ibu8+zVnk8JDnmxtq3eDilAraAy4YQInwWJ3DGdhuWRzC4e1S1oY33+UFurd62JS2g== mat@mosEisley"

ssh_pwauth: true
chpasswd:
  list: |
     root:letmein
     mat:passw0rd
  expire: false

# run some commands
runcmd:
- chmod --recursive mat:mat /home/mat
