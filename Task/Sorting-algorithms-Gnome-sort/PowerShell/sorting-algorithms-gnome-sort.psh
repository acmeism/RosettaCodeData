function gnomesort($a) {
    $size, $i, $j = $a.Count, 1, 2
    while($i -lt $size) {
        if ($a[$i-1] -le $a[$i]) {
            $i = $j
            $j++
        }
        else {
            $a[$i-1], $a[$i] = $a[$i], $a[$i-1]
            $i--
            if($i -eq 0) {
                $i = $j
                $j++
            }
        }
    }
    $a
}
$array = @(60, 21, 19, 36, 63, 8, 100, 80, 3, 87, 11)
"$(gnomesort $array)"
