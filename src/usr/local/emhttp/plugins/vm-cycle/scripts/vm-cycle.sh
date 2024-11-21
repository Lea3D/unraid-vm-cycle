#!/bin/bash

source /boot/config/plugins/vm-cycle/vmcyclesettings

############### End config

vm_running="running"
vm_down="shut off"

vm1_state=$(virsh domstate "$VM1")
vm2_state=$(virsh domstate "$VM2")

echo "$VM1 is $vm1_state"
echo "$VM2 is $vm2_state"

if [ "$vm1_state" = "$vm_running" ] && [ "$vm2_state" = "$vm_down" ]; then
	echo "$VM1 is running shutting down"
	virsh shutdown "$VM1"
	vm1_new_state=$(virsh domstate "$VM1")
	until [ "$vm1_new_state" = "$vm_down" ]; do
		echo "$VM1 $vm1_new_state"
		vm1_new_state=$(virsh domstate "$VM1")
		sleep 2
	done
	echo "$VM1 $vm1_new_state"
	sleep 2
	virsh start "$VM2"
	sleep 1
	vm2_new_state=$(virsh domstate "$VM2")
	echo "$VM2 $vm2_new_state"
else
	if [ "$vm2_state" = "$vm_running" ] && [ "$vm1_state" = "$vm_down" ]; then
		echo "$VM2 is running shutting down"
		virsh shutdown "$VM2"
		vm2_new_state=$(virsh domstate "$vm2")
		until [ "$vm2_new_state" = "$vm_down" ]; do
			echo "$VM2 $vm2_new_state"
			vm2_new_state=$(virsh domstate "$VM2")
			sleep 2
		done
		echo "$VM2 $vm2_new_state"
		sleep 2
		virsh start "$VM1"
		sleep 1
		vm1_new_state=$(virsh domstate "$VM1")
		echo "$VM1 $vm1_new_state"
	else
		echo "$VM1 $vm1_state and $VM2 $vm2_state doesnt match"
	fi
fi