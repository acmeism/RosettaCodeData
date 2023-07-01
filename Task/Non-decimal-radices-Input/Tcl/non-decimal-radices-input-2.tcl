proc scanbase {str base} {
   set res 0
   set digits {0 1 2 3 4 5 6 7 8 9 a b c d e f g h i j k l m n o p q r s t u v w x y z}
   foreach char [split [string tolower $str] ""] {
      set value [lsearch [lrange $digits 0 [expr {$base - 1}]] $char]
      if {$value < 0} {error "bad digit $char"}
      set res [expr {$res*$base + $value}]
   }
   return $res
}
