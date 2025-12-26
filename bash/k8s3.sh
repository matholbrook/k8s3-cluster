#!/bin/bash

declare -a cluster=(k8s3-vm1 k8s3-vm2 k8s3-vm3)

case "$1" in
    list)
        virsh list
        ;;
    net)
        for vm in "${cluster[@]}"; do
            virsh domifaddr ${vm}
        done
        ;;
    up)
        for vm in "${cluster[@]}"; do
            echo "starting vm ${vm} ..."
            virsh start ${vm}
            sleep 2
        done
        ;;
    down)
        for vm in "${cluster[@]}"; do
            echo "stopping vm ${vm} ..."
            virsh shutdown ${vm}
        done
        ;;
    *)
        echo "you must use one of the following [list, up, down]"
        ;;
esac
