proc encoder int {
   set u [format %c $int]
   set bytes {}
   foreach byte [split [encoding convertto utf-8 $u] ""] {
      lappend bytes [format %02X [scan $byte %c]]
   }
   return $bytes
}
proc decoder bytes {
   set str {}
   foreach byte $bytes {
      append str [format %c [scan $byte %x]]
   }
   return [encoding convertfrom utf-8 $str]
}
foreach test {0x0041 0x00f6 0x0416 0x20ac 0x1d11e} {
   set res $test
   lappend res [encoder $test] -> [decoder [encoder $test]]
   puts $res
}
