Function Get-GCD( $x, $y ) {
    while ($y -ne 0) {
        $x, $y = $y, ($x % $y)
    }
    [Math]::abs($x)
}
