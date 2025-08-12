proc lzip {l1 l2} {
    set zipped {}
    foreach x $l1 y $l2 {
        lappend zipped $x $y
    }
   return $zipped
}

proc search {arr key} {
    set k_idx [lsearch $arr $key]
    if {$k_idx ne -1} {
       set v_idx [expr {$k_idx + 1}]
       return [lindex $arr $v_idx]
    } else {
       return {}
    }
}
set a {1 2 3 4}
set b {a b c d}

set arr  [lzip $a $b]

puts "\{$arr\}\n"

set res [search $arr 3]

puts "$res"
