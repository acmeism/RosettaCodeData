puts "# True random chars for one-time pad"

proc randInt { min max } {
    set randDev [open /dev/urandom rb]
    set random [read $randDev 8]
    binary scan $random H16 random
    set random [expr {([scan $random %x] % (($max-$min) + 1) + $min)}]
    close $randDev
    return $random
}

proc randStr { sLen grp alfa } {
  set aLen [string length $alfa]; incr aLen -1
  set rs ""
  for {set i 0} {$i < $sLen} {incr i} {
    if { [expr {$i % $grp} ] == 0} { append rs " " }
    set r [randInt 0 $aLen]
    set char [string index $alfa $r]
    append rs $char
  ##puts "$i: $r $char"
  }
  return $rs
}

set alfa "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
set len 48
set lines 4
set fn "test.1tp"

# Write file:
set fh [open $fn w]
puts $fh "# OTP"
for {set ln 0} {$ln < $lines} {incr ln} {
    set line [randStr $len 6 $alfa]
  ##puts "$ln :$line."
    puts $fh $line
}
close $fh

# Read file:
puts "# File $fn:"
set fh [open $fn]
puts [read $fh [file size $fn]]
close $fh

puts "# Done."
