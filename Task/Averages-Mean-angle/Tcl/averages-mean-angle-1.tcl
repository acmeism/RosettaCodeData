proc meanAngle {angles} {
    set toRadians [expr {atan2(0,-1) / 180}]
    set sumSin [set sumCos 0.0]
    foreach a $angles {
	set sumSin [expr {$sumSin + sin($a * $toRadians)}]
	set sumCos [expr {$sumCos + cos($a * $toRadians)}]
    }
    # Don't need to divide by counts; atan2() cancels that out
    return [expr {atan2($sumSin, $sumCos) / $toRadians}]
}
