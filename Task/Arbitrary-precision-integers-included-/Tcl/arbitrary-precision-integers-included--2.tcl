#/usr/bin/env  tclsh

# find executable
if {$tcl_platform(platform) eq "windows"} {
    variable bc [auto_execok bc.exe]
  else {
    variable bc [auto_execok bc]
}

proc bc_calc {args} {
    variable bc
    return [exec echo $args | $bc -l]
}

set start [clock milliseconds]

set x [bc_calc  "5^4^3^2"]

set stop [clock milliseconds]

puts stdout "x:  [string length $x] digits"

puts stdout "first 10 digits: [string range $x 0 9]"

puts stdout "last  10 digits: [string range $x end-9  end]"

puts "elapsed time:  [expr {$stop - $start}] msec"
