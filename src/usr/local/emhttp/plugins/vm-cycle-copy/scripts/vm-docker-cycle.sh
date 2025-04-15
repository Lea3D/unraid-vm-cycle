#!/bin/bash

source /boot/config/plugins/vm-cycle-copy/vmcyclesettings

############### End config

log_message() {
  while IFS= read -r line; do
    logger "vm-cycle: ${line}"
  done
}
exec > >(log_message) 2>&1

vm_running="running"
vm_down="shut off"

vmd_state=$(virsh domstate "$VMD")

echo "$VMD is $vmd_state"

if [ "$vmd_state" = "$vm_running" ]; then
        echo "$VMD is running shutting down"
        virsh shutdown "$VMD"
        vmd_new_state=$(virsh domstate "$VMD")
        until [ "$vmd_new_state" = "$vm_down" ]; do
                echo "$VMD $vmd_new_state"
                vmd_new_state=$(virsh domstate "$VMD")
                sleep 2
        done
        echo "$VMD $vmd_new_state"
        sleep 2
        docker start "$DOCKERS"
        sleep 1
        echo "$DOCKERS started"
else
        if [ "$vmd_state" = "$vm_down" ]; then
                echo "$DOCKERS shutting down"
                docker stop "$DOCKERS"
                echo "stopping $DOCKERS"
                sleep 2
                virsh start "$VMD"
                sleep 1
                vmd_new_state=$(virsh domstate "$VMD")
                echo "$VMD $vmd_new_state"
        else
                echo "$VMD $vmd_state and $DOCKERS doesnt match"
        fi
fi