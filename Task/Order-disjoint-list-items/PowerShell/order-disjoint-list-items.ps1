function sublistsort($M, $N) {
    $arr = $M.Split(' ')
    $array = $N.Split(' ') | group
    $Count = @($array |foreach {$_.Count})
    $ip, $i = @(), 0
    $arr | foreach{
        $name = "$_"
        $j = $array.Name.IndexOf($name)
        if($j -gt -1){
            $k = $Count[$j] - 1
            if($k -ge 0) {
                $ip += @($i)
                $Count[$j] = $k
            }
        }
        $i++
    }
    $i = 0
    $N.Split(' ') | foreach{ $arr[$ip[$i++]] = "$_"}
    [pscustomobject]@{
        "M" = "$M "
        "N" = "$N "
        "M'" = "$($arr)"
    }
}
$M1 = 'the cat sat on the mat'
$N1 =  'mat cat'
$M2 = 'the cat sat on the mat'
$N2 = 'cat mat'
$M3 = 'A B C A B C A B C'
$N3 = 'C A C A'
$M4 = 'A B C A B D A B E'
$N4 = 'E A D A'
$M5 = 'A B'
$N5 = 'B'
$M6 = 'A B'
$N6 = 'B A'
$M7 = 'A B B A'
$N7 = 'B A'
sublistsort $M1 $N1
sublistsort $M2 $N2
sublistsort $M3 $N3
sublistsort $M4 $N4
sublistsort $M5 $N5
sublistsort $M6 $N6
sublistsort $M7 $N7
