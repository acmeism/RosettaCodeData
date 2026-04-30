function div ($a, $b) {
    try{$a/$b}
    catch{"Bad parameters: `$a = $a and `$b = $b"}
}
div 10 2
div 1 0
