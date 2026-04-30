function transpose($a) {
    if($a) {
        $n = $a.Count - 1
        foreach($i in 0..$n) {
            $j = 0
            while($j -lt $i) {
                $a[$i][$j], $a[$j][$i] = $a[$j][$i], $a[$i][$j]
                $j++
            }
        }
    }
    $a
}
function show($a) {
    if($a) {
        0..($a.Count - 1) | foreach{ if($a[$_]){"$($a[$_])"}else{""} }
    }
}
$a = @(@(2, 4, 7),@(3, 5, 9),@(4, 1, 6))
show $a
""
show (transpose $a)
