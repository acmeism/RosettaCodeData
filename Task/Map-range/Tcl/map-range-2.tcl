interp alias {} demomap {} rangemap {0 10} {-1 0}
for {set i 0} {$i <= 10} {incr i} {
    puts [format "%2d -> %5.2f" $i [demomap $i]]
}
