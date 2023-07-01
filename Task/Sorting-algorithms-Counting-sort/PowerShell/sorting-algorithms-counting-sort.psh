function countingSort($array) {
    $minmax = $array | Measure-Object -Minimum -Maximum
    $min, $max = $minmax.Minimum, $minmax.Maximum
    $count = @(0) * ($max - $min  + 1)
    foreach ($number in $array) {
        $count[$number - $min] = $count[$number - $min] + 1
    }
    $z = 0
    foreach ($i in $min..$max) {
        while (0 -lt $count[$i - $min]) {
            $array[$z] = $i
            $z = $z+1
            $count[$i - $min] = $count[$i - $min] - 1
        }
    }
    $array
}

$array = foreach ($i in 1..50) {Get-Random -Minimum 0 -Maximum 26}
"$array"
"$(countingSort $array)"
