function multiple-value ($a, $b) {
    [pscustomobject]@{
        a = $a
        b = $b
    }
}
$m =  multiple-value "value" 1
$m.a
$m.b
