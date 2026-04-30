function power-set ($array) {
    if($array) {
        $n = $array.Count
        function state($set, $i){
            if($i -gt -1) {
                state $set ($i-1)
                state ($set+@($array[$i])) ($i-1)
            } else {
                "$($set | sort)"
            }
        }
        $set = state @() ($n-1)
        $power = 0..($set.Count-1) | foreach{@(0)}
        $i = 0
        $set | sort | foreach{$power[$i++] = $_.Split()}
        $power | sort {$_.Count}
    } else {@()}

}
$OFS = " "
$setA = power-set  @(1,2,3,4)
"number of sets in setA: $($setA.Count)"
"sets in setA:"
$OFS = ", "
$setA | foreach{"{"+"$_"+"}"}
$setB = @()
"number of sets in setB: $($setB.Count)"
"sets in setB:"
$setB | foreach{"{"+"$_"+"}"}
$setC = @(@(), @(@()))
"number of sets in setC: $($setC.Count)"
"sets in setC:"
$setC | foreach{"{"+"$_"+"}"}
$OFS = " "
