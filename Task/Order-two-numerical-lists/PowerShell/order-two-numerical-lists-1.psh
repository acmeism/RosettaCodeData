function  order($as,$bs) {
    if($as -and $bs) {
        $a, $as = $as
        $b, $bs = $bs
        if($a -eq $b) {order $as $bs}
        else{$a -lt $b}
    } elseif ($bs) {$true} else {$false}
}
"$(order @(1,2,1,3,2) @(1,2,0,4,4,0,0,0))"
