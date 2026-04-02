set project [lindex $argv $argc-1]
load $project.mag

extract
ext2spice lvs
ext2spice cthresh 0
ext2spice -d -o $project.spice
quit -noprompt
