$limit = 20
$data  = @("3 Fizz","5 Buzz","7 Baxx")
	#An array with whitespace as the delimiter
	#Between the factor and the word

for ($i = 1;$i -le $limit;$i++){
	$outP = ""
	foreach ($x in $data){
		$data_split = $x -split " "	#Split the "<factor> <word>"
		if (($i % $data_split[0]) -eq 0){
			$outP += $data_split[1]	#Append the <word> to outP
		}
	}
	if(!$outP){	#Is outP equal to NUL?
		Write-HoSt $i
	} else {
		Write-HoSt $outP
	}
}
