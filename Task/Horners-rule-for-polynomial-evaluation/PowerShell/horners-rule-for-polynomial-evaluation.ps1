function horner($coefficients, $x) {
    $accumulator = 0
    foreach($i in ($coefficients.Count-1)..0){
        $accumulator = ( $accumulator * $x ) + $coefficients[$i]
    }
    $accumulator
}
$coefficients = @(-19, 7, -4, 6)
$x = 3
horner $coefficients $x
