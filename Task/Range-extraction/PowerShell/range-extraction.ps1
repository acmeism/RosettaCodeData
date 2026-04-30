function range-extraction($arr) {
    if($arr.Count -gt 2) {
        $a, $b, $c, $arr = $arr
        $d = $e = $c
        if((($a + 1) -eq $b) -and (($b + 1) -eq $c)) {
            $test = $true
            while($arr -and $test) {
                $d = $e
                $e, $arr = $arr
                $test = ($d+1) -eq $e
            }
            if($test){"$a-$e"}
            elseif((-not $arr) -and $test){"$a-$d"}
            elseif(-not $arr){"$a-$d,$e"}
            else{"$a-$d," + (range-extraction (@($e)+$arr))}
        }
        elseif(($b + 1) -eq $c) {"$a," + (range-extraction (@($b, $c)+$arr))}
        else {"$a,$b," + (range-extraction (@($c)+$arr))}
    } else {
        switch($arr.Count) {
            0 {""}
            1 {"$arr"}
            2 {"$($arr[0]),$($arr[1])"}
        }
    }
}
range-extraction @(0,  1,  2,  4,  6,  7,  8, 11, 12, 14,
15, 16, 17, 18, 19, 20, 21, 22, 23, 24,
25, 27, 28, 29, 30, 31, 32, 33, 35, 36,
37, 38, 39)
