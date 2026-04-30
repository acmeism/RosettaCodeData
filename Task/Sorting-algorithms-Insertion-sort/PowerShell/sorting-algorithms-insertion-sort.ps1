function insertionSort($arr){
	for($i=0;$i -lt $arr.length;$i++){
		$val = $arr[$i]
		$j = $i-1
		while($j -ge 0 -and $arr[$j] -gt $val){
			$arr[$j+1] = $arr[$j]
			$j--
		}
		$arr[$j+1] = $val
	}
}

$arr = @(4,2,1,6,9,3,8,7)
insertionSort($arr)
$arr -join ","
