set toTTY [dict exists [fconfigure stdout] -mode]
puts [expr {$toTTY ? "Output goes to tty" : "Output doesn't go to tty"}]
