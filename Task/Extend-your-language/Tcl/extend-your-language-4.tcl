proc loop {varName lowerBound upperBound body} {
    upvar 1 $varName var
    for {set var $lowerBound} {$var <= $upperBound} {incr var} {
        uplevel 1 $body
    }
}
