proc validISBN13 code {
   regsub -all {\D} $code "" code ;# remove non-digits
   if {[string length $code] == 13} {
      set sum 0
      set fac 1
      foreach digit [split $code ""] {
         set sum [expr {$sum + $digit * $fac}]
         set fac [expr {$fac == 1? 3: 1}]
      }
      if {$sum % 10 == 0} {return true}
   }
   return false
}
foreach test {
   978-0596528126
   978-0596528120
   978-1788399081
   978-1788399083
} {puts $test:[validISBN13 $test]}
