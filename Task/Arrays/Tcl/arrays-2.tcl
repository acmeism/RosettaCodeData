set x [lindex $arr 4]  ; #  x <= 5

foreach n $arr {
   set idx [expr n -1]
 lset arr $idx [expr $n * $n]
}

puts stdout "$arr"
