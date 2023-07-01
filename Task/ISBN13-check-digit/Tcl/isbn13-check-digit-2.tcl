proc validISBN13 code {
   regsub -all {\D} $code "" code ;# remove non-digits
   if {[string length $code] == 13} {
      set sum 0
      foreach {d1 d2} [split $code ""] {
         if {$d2 eq ""} {set d2 0} ;# last round
         set sum [expr {$sum + $d1 + $d2 * 3}]
      }
      if {$sum % 10 == 0} {return true}
   }
   return false
}
