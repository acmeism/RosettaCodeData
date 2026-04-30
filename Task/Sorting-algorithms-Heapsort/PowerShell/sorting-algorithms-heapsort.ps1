function heapsort($a, $count) {
   $a = heapify $a $count
   $end = $count - 1
   while( $end -gt 0) {
      $a[$end], $a[0] = $a[0], $a[$end]
      $end--
      $a = siftDown $a 0 $end
    }
    $a
}
function heapify($a, $count) {
   $start = [Math]::Floor(($count - 2) / 2)
   while($start -ge 0) {
      $a = siftDown $a $start ($count-1)
      $start--
   }
   $a
}
function siftdown($a, $start, $end) {
   $b, $root = $true, $start
   while(( ($root * 2 + 1) -le $end) -and $b) {
      $child = $root * 2 + 1
      if( ($child + 1 -le $end) -and ($a[$child] -lt $a[$child + 1]) ) {
         $child++
      }
      if($a[$root] -lt $a[$child]) {
        $a[$root], $a[$child] = $a[$child], $a[$root]
        $root = $child
      }
      else { $b = $false}
    }
    $a
}
$array = @(60, 21, 19, 36, 63, 8, 100, 80, 3, 87, 11)
"$(heapsort $array $array.Count)"
