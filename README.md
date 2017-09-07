# vmbackup-xenserver
Bash script for backing up Xenserver VMs 

Normal_backup.sh

What does it do?

You want to auto backup (create a clone of your VM) on another SR? Then, this script is for you.
This bash shell will do following steps for backing up XEN server VM:
- Get your VM name and SR name (where you want to store your backed up VM)
- Create a snapshot from your VM current state.
  This should take less than 5 seconds, and doesn't impact your VM's performance.
- Copy created snapshot to destination SR.
  This should take while a long time, depend on your VM disk's size and SR's write speed.
- Create backed up VM from snapshot.
  New VM will be named by "name+current_date"
- Clean up by removing snapshots.
- Wait 120 seconds before processing another VM.

DetachHDD_backup.sh

What does it do?

Imagine you have a VM with 2 disk: 1 10GB-disk for system, and 1-200GB-disk for data. For some reason, you don't want to back up the data disk. Then, this script is just for you.
This bash shell will do following steps for backing up XEN server VM:
- Get your VM name, SR name (where you want to store your backed up VM), HDD name (the disk you don't want to be backed up).
- Shutdown your VM (need XEN tool installed on your VM)
- Detach data disk.
- Create a snapshot from your VM current state.
  This should take less than 5 seconds, and doesn't impact your VM's performance.
- Copy created snapshot to destination SR.
  This should take while a long time, depend on your VM disk's size and SR's write speed.
- Create backed up VM from snapshot.
  New VM will be named by "name+current_date"
- Clean up by removing snapshots.
- Attach data disk to your current VM again (not the backed up VM).
- Start your VM
- Wait 120 seconds before processing another VM.


How to setup?
- Make sure you have enought privileges to log into XEN server host console (not VM console).
  Or you can SSH to your XEN server host, it shoud be easier to copy/paste command.
- Create a new bash script or SCP this script to your XEN server host.
- Change vm_name and destSR_name variable to match your environment.
- (if you use DetachHDD_backup, install XEN tool to your VM, which you're going to back up)
- Give the script execution permission (chmod 750 should do the trick).
- Run script.
- Monitor the script by output on console.
  You will see a snapshot on your being backed up VM. Also, your SR IOPS will rise.
  After that, a new VM with (VM_name_date) will appear, and all snapshot will be removed.
- Set up a crontab to run this script at night would be nice  :)


Why i make this repository?

Well, we use XEN server in our production for a long time. With no money invested to managing solution, it took our IT guys a lot of time to backup VM weekly. After googling for a while, I found no simple solution for this task, so I decided to write my own.

Hope this help you guys  :)

If you have time, leave me a comment about what need to be improved.
