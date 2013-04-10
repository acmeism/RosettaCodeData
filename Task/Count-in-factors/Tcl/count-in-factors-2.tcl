set max 20
for {set i 1} {$i <= $max} {incr i} {
    puts [format "%*d = %s" [string length $max] $i [prime::factors.rendered $i]]
}
