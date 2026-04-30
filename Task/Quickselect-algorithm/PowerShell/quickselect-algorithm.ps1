 function partition($list, $left, $right, $pivotIndex) {
     $pivotValue = $list[$pivotIndex]
     $list[$pivotIndex], $list[$right] = $list[$right], $list[$pivotIndex]
     $storeIndex = $left
     foreach ($i in $left..($right-1)) {
         if ($list[$i] -lt $pivotValue) {
             $list[$storeIndex],$list[$i] = $list[$i], $list[$storeIndex]
             $storeIndex += 1
         }
     }
     $list[$right],$list[$storeIndex] = $list[$storeIndex], $list[$right]
     $storeIndex
}

function rank($list, $left, $right, $n) {
    if ($left -eq $right) {$list[$left]}
    else {
        $pivotIndex = Get-Random -Minimum $left -Maximum $right
        $pivotIndex = partition $list $left $right $pivotIndex
        if ($n -eq $pivotIndex) {$list[$n]}
        elseif ($n -lt $pivotIndex) {(rank $list $left ($pivotIndex - 1) $n)}
        else {(rank $list ($pivotIndex+1) $right $n)}
    }
}

function quickselect($list) {
    $right = $list.count-1
    foreach($left in 0..$right) {rank $list $left $right $left}
}
$arr = @(9, 8, 7, 6, 5, 0, 1, 2, 3, 4)
"$(quickselect $arr)"
