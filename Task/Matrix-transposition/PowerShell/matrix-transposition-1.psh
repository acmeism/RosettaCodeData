function transpose($a) {
    $arr = @()
    if($a) {
        $n = $a.count - 1
        if(0 -lt $n) {
            $m = ($a | foreach {$_.count} | measure-object -Minimum).Minimum - 1
            if( 0 -le $m) {
                if (0 -lt $m) {
                    $arr =@(0)*($m+1)
                    foreach($i in 0..$m) {
                        $arr[$i] = foreach($j in 0..$n) {@($a[$j][$i])}
                    }
                } else {$arr = foreach($row in $a) {$row[0]}}
            }
        } else {$arr = $a}
    }
    $arr
}
function show($a) {
    if($a) {
        0..($a.Count - 1) | foreach{ if($a[$_]){"$($a[$_])"}else{""} }
    }
}

$a = @(@(2, 0, 7, 8),@(3, 5, 9, 1),@(4, 1, 6, 3))
"`$a ="
show $a
""
"transpose `$a ="
show (transpose $a)
""
$a = @(1)
"`$a ="
show $a
""
"transpose `$a ="
show (transpose $a)
""
"`$a ="
$a = @(1,2,3)
show $a
""
"transpose `$a ="
"$(transpose $a)"
""
"`$a ="
$a = @(@(4,7,8),@(1),@(2,3))
show $a
""
"transpose `$a ="
"$(transpose $a)"
""
"`$a ="
$a = @(@(4,7,8),@(1,5,9,0),@(2,3))
show $a
""
"transpose `$a ="
show (transpose $a)
