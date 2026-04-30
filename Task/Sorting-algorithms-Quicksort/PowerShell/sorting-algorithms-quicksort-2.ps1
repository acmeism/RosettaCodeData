function quicksort($array) {
    $less, $equal, $greater = @(), @(), @()
    if( $array.Count -gt 1 ) {
        $pivot = $array[0]
        foreach( $x in $array) {
            if($x -lt $pivot) { $less += @($x) }
            elseif ($x -eq $pivot) { $equal += @($x)}
            else { $greater += @($x) }
        }
        $array = (@(quicksort $less) + @($equal) + @(quicksort $greater))
    }
    $array
}
$array = @(60, 21, 19, 36, 63, 8, 100, 80, 3, 87, 11)
"$(quicksort $array)"
