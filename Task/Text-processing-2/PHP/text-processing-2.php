$handle = fopen("readings.txt", "rb");
$missformcount = 0;
$totalcount = 0;
$dates = array();
while (!feof($handle)) {
    $buffer = fgets($handle);
	$line = preg_replace('/\s+/',' ',$buffer);
	$line = explode(' ',trim($line));
	$datepattern = '/^\d{4}-\d{2}-\d{2}$/';
	$valpattern = '/^\d+\.{1}\d{3}$/';
	$flagpattern = '/^[1-9]{1}$/';
	
	if(count($line) != 49) $missformcount++;
	if(!preg_match($datepattern,$line[0],$check)) $missformcount++;
	else $dates[$totalcount+1] = $check[0];
	
	$errcount = 0;
	for($i=1;$i<count($line);$i++){
		if($i%2!=0){
			if(!preg_match($valpattern,$line[$i],$check)) $errcount++;
		}else{
			if(!preg_match($flagpattern,$line[$i],$check)) $errcount++;
		}
	}
	if($errcount != 0) $missformcount++;
	$totalcount++;
}
fclose ($handle);
$good = $totalcount - $missformcount;
$duplicates = array_diff_key( $dates , array_unique( $dates ));
echo 'Valid records ' . $good . ' of ' . $totalcount . ' total<br>';
echo 'Duplicates : <br>';
foreach ($duplicates as $key => $val){
	echo $val . ' at Line : ' . $key . '<br>';
}
