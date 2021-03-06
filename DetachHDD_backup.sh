
######Backup VM, detach 1 disk before backing up###################
vm_name="YourVM-name"
date
echo "Backing up VM:" $vm_name
destSR_name="YourSR-name"
sr_id=$(xe sr-list name-label=ScaleIO_4TB|grep "uuid ( RO)  "|awk -F: '{print $2}'|cut -c 2-)
echo "Destionation:" $destSR_name "uuid:" $sr_id
hdd_name="YourDATAHDD-name"
echo "Exclude HDD:" $hdd_name
xe vm-shutdown vm=$vm_name
echo "Shutdown VM:" $vm_name
vbd_id=$(xe vbd-list vdi-name-label=$hdd_name | grep "uuid ( RO)  "|awk -F: '{print $2}'|cut -c 2-)
vm_id=$(xe vbd-list vdi-name-label=$hdd_name | grep "vm-uuid ( RO)"|awk -F: '{print $2}'|cut -c 2-)
hdd_id=$(xe vbd-list vdi-name-label=$hdd_name | grep "vdi-uuid ( RO)"|awk -F: '{print $2}'|cut -c 2-)
xe vbd-destroy uuid=$vbd_id
echo "Remove HDD connection:" $vbd_id
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
newvbd_id=$(xe vbd-create vm-uuid=$vm_id vdi-uuid=$hdd_id device=1 type=Disk mode=RW bootable=false)
echo "Create new HDD connection:" $newvbd_id
xe vm-start vm=$vm_name
echo "Start VM:" $vm_name
date
echo
sleep 120
