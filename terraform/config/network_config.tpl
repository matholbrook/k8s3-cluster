network:
  version: 2
  ethernets:
    ens3:
      dhcp4: false
      dhcp6: false
      addresses: [${ipaddress}]
      gateway4: 192.168.122.1
      nameservers:
        addresses: [192.168.122.1]
      routes:
        - to: 0.0.0.0/0
          via: 192.168.122.1
