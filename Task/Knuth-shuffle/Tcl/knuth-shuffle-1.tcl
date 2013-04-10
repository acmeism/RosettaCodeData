proc knuth_shuffle lst {
   set j [llength $lst]
   for {set i 0} {$j > 1} {incr i;incr j -1} {
       set r [expr {$i+int(rand()*$j)}]
       set t [lindex $lst $i]
       lset lst $i [lindex $lst $r]
       lset lst $r $t
   }
   return $lst
}

% knuth_shuffle {1 2 3 4 5}
2 1 3 5 4
% knuth_shuffle {1 2 3 4 5}
5 2 1 4 3
% knuth_shuffle {tom dick harry peter paul mary}
tom paul mary harry peter dick
