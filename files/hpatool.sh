#! /bin/bash

CLIBIN=/usr/sbin/hpacucli


is_root() {
   if [[ $EUID -ne 0 ]]; then
      echo "$0 must be run as root" 1>&2
      exit 1
   fi
}

show_controller_status() {
   echo "Controller status:"
   ${CLIBIN} controller all show status
}

show_detail() {
   echo "Disk(s) detail:"
   ${CLIBIN} ctrl slot=1 pd all show detail  # | grep -i -P '.*(physicaldrive|Firmware|Status).*'
}

show_disk_physical_info() {
   echo "Disk(s) physical info:"
   for i in $(${CLIBIN} ctrl all show | awk '{ print $6 }')
   do
      echo "Slot $i:"
      ${CLIBIN} ctrl slot=$i pd all show
   done
}

show_all_arrays() {
   echo "All current arrays on controller slot 1"
   ${CLIBIN} controller slot=1 array all show
}


# led_switch <disk> <on|off>
led_switch() {
   pdisk=$0
   switch=$1
   ${CLIBIN} ctrl slot=1 pd ${pdisk} modify led=${switch}
}

get_unassigned_list() {
   ${CLIBIN} controller slot=1 physicaldrive allunassigned show | grep "..\:.\:[0-9]*" | awk '{print $2}'
}

assign_all_disks() {
   for disk in  $(get_unassigned_list)
   do
      echo "Assigning disk $d"
      led_switch $disk on
      ${CLIBIN} controller slot=1 create type=ld drives=$disk raid=0
      led_switch $disk off
   done
}

is_root
if [ "x$(get_unassigned_list)" = "x" ]; then
    exit 1
fi
assign_all_disks

exit 0;
