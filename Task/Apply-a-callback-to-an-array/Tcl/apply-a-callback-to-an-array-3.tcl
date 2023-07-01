proc map {f list} {
   set res {}
   foreach e $list {lappend res [$f $e]}
   return $res
}
proc square x {expr {$x*$x}}

% map square {1 2 3 4 5}
1 4 9 16 25
