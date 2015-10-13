function permutation ($array) {
    function generate($n, $array, $A) {
        if($n -eq 1) {
            $array[$A] -join ''
        }
        else{
            for( $i = 0; $i -lt ($n - 1); $i += 1) {
                generate ($n - 1) $array $A
                if($n % 2 -eq 0){
                    $i1, $i2 = $i, ($n-1)
                    $temp = $A[$i1]
                    $A[$i1] = $A[$i2]
                    $A[$i2] = $temp
                }
                else{
                    $i1, $i2 = 0, ($n-1)
                    $temp = $A[$i1]
                    $A[$i1] = $A[$i2]
                    $A[$i2] = $temp
                }
            }
            generate ($n - 1) $array $A
        }
    }
    $n = $array.Count
    if($n -gt 0) {
        (generate $n $array (0..($n-1)))
    } else {$array}
}
$perm = permutation @('A','B','C', 'D')
$find = @(
"ABCD"
"CABD"
"ACDB"
"DACB"
"BCDA"
"ACBD"
"ADCB"
"CDAB"
"DABC"
"BCAD"
"CADB"
"CDBA"
"CBAD"
"ABDC"
"ADBC"
"BDCA"
"DCBA"
"BACD"
"BADC"
"BDAC"
"CBDA"
"DBCA"
"DCAB"
)
$perm | where{-not $find.Contains($_)}
