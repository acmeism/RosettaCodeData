proc div_check {x y} {
    try {
        puts "valid division: $x/$y=[expr {$x/$y}]"
    } trap {ARITH DIVZERO} msg {
        puts "caught division by zero: $x/$y -> $msg"
    } trap {ARITH DOMAIN} msg {
        puts "caught bad division: $x/$y -> $msg"
    } on error msg {
        puts "caught another error: $x/$y -> $msg"
    }
}

foreach {num denom} {42 1  42 0  42.0 0.0  0 0  0.0 0.0  0 foo} {
    div_check $num $denom
}
