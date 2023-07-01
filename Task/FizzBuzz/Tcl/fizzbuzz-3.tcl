set f [lrepeat 5 "Fizz" {$i} {$i}]
foreach i {5 10} {lset f $i "Buzz"};lset f 0 "FizzBuzz"
for {set i 1} {$i <= 100} {incr i} {
    puts [subst [lindex [set f [list {*}[lassign $f ff] $ff]] 0]]
}
