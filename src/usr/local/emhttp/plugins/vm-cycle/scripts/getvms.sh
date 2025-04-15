#!/bin/bash
#

FILTER="$1"

case "$FILTER" in
  running)
    virsh list --state-running --name
    ;;
  stopped)
    virsh list --state-shutoff --name
    ;;
  passthrough)
    for vm in $(virsh list --all --name); do
      virsh dumpxml "$vm" | grep -q "<hostdev" && echo "$vm"
    done
    ;;
  pci)
    for vm in $(virsh list --all --name); do
      virsh dumpxml "$vm" | grep -q "<hostdev.*type='pci'" && echo "$vm"
    done
    ;;
  usb)
    for vm in $(virsh list --all --name); do
      virsh dumpxml "$vm" | grep -q "<hostdev.*type='usb'" && echo "$vm"
    done
    ;;
  all|*)
    virsh list --all --name
    ;;
esac
