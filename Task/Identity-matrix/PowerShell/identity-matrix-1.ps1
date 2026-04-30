function identity($n) {
    0..($n-1) | foreach{$row = @(0) * $n; $row[$_] = 1; ,$row}
}
function show($a) { $a | foreach{ "$_"} }
$array = identity 4
show $array
