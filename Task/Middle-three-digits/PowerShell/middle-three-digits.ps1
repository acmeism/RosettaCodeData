function middle3($inp){

	$str = [Math]::abs($inp)

	$leng = "$str".length

	if ($leng -lt 3){
		Write-host $inp":	[ERROR] too short."
		Return
	}
	if (($leng % 2) -eq 0){
		Write-host $inp":	[ERROR] even number of digits."
	} else {
		$trimmer = ($leng - 3) / 2
		$ans = "$str".subString($trimmer,3)

		Write-host $inp":	$ans"
	}
	Return
}

$sample = 123, 12345, 1234567, 987654321, 10001, -10001, -123, -100, 100, -12345, 1, 2, -1, -10, 2002, -2002, 0

foreach ($x in $sample){middle3 $x}
