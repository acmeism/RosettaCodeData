proc div_check {x y} {
    if {[catch {expr {$x/$y}} result] == 0} {
        puts "valid division: $x/$y=$result"
    } else {
        if {$result eq "divide by zero"} {
            puts "caught division by zero: $x/$y -> $result"
        } else {
            puts "caught another error: $x/$y -> $result"
        }
    }
}

foreach denom {1 0 foo} {
    div_check 42 $denom
}
