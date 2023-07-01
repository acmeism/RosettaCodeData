proc powersetb set {
   set res {}
   for {set i 0} {$i < 2**[llength $set]} {incr i} {
      set pos -1
      set pset {}
      foreach el $set {
          if {$i & 1<<[incr pos]} {lappend pset $el}
      }
      lappend res $pset
   }
   return $res
}
