<?php
	//First Task
	for($i=1;$i<=22;$i++){
		echo($i + floor(1/2 + sqrt($i)) . "\n");
	}

	//Second Task
	$found_square=False;
	for($i=1;$i<=1000000;$i++){
		$non_square=$i + floor(1/2 + sqrt($i));
		if(sqrt($non_square)==intval(sqrt($non_square))){
			$found_square=True;
		}
	}
	echo("\n");
	if($found_square){
		echo("Found a square number, so the formula does not always work.");
	} else {
		echo("Up to 1000000, found no square number in the sequence!");
	}
?>
