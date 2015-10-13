function det-perm ($array) {
    if($array) {
        $size = $array.Count
        function prod($A) {
            $prod = 1
            if($A) { $A | foreach{$prod *= $_} }
            $prod
        }
        function generate($sign, $n, $A) {
            if($n -eq 1) {
                $i = 0
                $prod = prod @($A | foreach{$array[$i++][$_]})
                [pscustomobject]@{det = $sign*$prod; perm = $prod}
            }
            else{
                for($i = 0; $i -lt ($n - 1); $i += 1) {
                    generate $sign ($n - 1) $A
                    if($n % 2 -eq 0){
                        $i1, $i2 = $i, ($n-1)
                        $A[$i1], $A[$i2] = $A[$i2], $A[$i1]
                    }
                    else{
                        $i1, $i2 = 0, ($n-1)
                        $A[$i1], $A[$i2] = $A[$i2], $A[$i1]
                    }
                    $sign *= -1
                }
                generate $sign ($n - 1) $A
            }
        }
        $det = $perm = 0
        generate 1 $size @(0..($size-1)) | foreach{
            $det += $_.det
            $perm += $_.perm
        }
        [pscustomobject]@{det =  "$det"; perm = "$perm"}
    } else {Write-Error "empty array"}
}
det-perm 5
det-perm @(@(1,0,0),@(0,1,0),@(0,0,1))
det-perm @(@(0,0,1),@(0,1,0),@(1,0,0))
det-perm @(@(4,3),@(2,5))
det-perm @(@(2,5),@(4,3))
det-perm @(@(4,4),@(2,2))
