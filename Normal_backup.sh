#!/bin/bash

#######Backup normal VM###############
# Change YourVM-name and YourSR-name to what you need

vm_name="YourVM-name"
date
echo "Backing up VM:" $vm_name
destSR_name="YourSR-name"
sr_id=$(xe sr-list name-label=$destSR_name|grep "uuid ( RO)  "|awk -F: '{print $2}'|cut -c 2-)
echo "Destionation:" $destSR_name "uuid:" $sr_id
snap_uuid=$(xe vm-snapshot vm=$vm_name new-name-label=$vm_name-bkss new-name-description=$vm_name-bkss)
echo "Created snapshot uuid:" $snap_uuid
snapcopy_uuid=$(xe snapshot-copy new-name-label=$vm_name-template new-name-description=$vm_name-template uuid=$snap_uuid sr-uuid=$sr_id)
echo "Copied snapshot uuid:" $snapcopy_uuid
newvm_uuid=$(xe vm-install template=$vm_name-template new-name-label=$vm_name-$(date +'%d')$(date +'%m')$(date +'%Y'))
echo "Created backup VM, uuid:" $newvm_uuid
xe template-uninstall template-uuid=$snapcopy_uuid force=true
echo "Cleaned up template."
xe snapshot-uninstall snapshot-uuid=$snap_uuid force=true
echo "Cleaned up snapshot."
date
echo
sleep 120
# wait 120 second before continue processing another VM
