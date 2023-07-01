proc cartesianProduct {l1 l2} {
  set result {}
  foreach el1 $l1 {
    foreach el2 $l2 {
      lappend result [list $el1 $el2]
    }
  }
  return $result
}

puts "simple"
puts "result: [cartesianProduct {1 2} {3 4}]"
puts "result: [cartesianProduct {3 4} {1 2}]"
puts "result: [cartesianProduct {1 2} {}]"
puts "result: [cartesianProduct {} {3 4}]"

proc cartesianNaryProduct {lists} {
  set result {{}}
  foreach l $lists {
    set res {}
    foreach comb $result {
      foreach el $l {
        lappend res [linsert $comb end $el]
      }
    }
    set result $res
  }
  return $result
}

puts "n-ary"
puts "result: [cartesianNaryProduct {{1776 1789} {7 12} {4 14 23} {0 1}}]"
puts "result: [cartesianNaryProduct {{1 2 3} {30} {500 100}}]"
puts "result: [cartesianNaryProduct {{1 2 3} {} {500 100}}]"
