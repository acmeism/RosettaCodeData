<?php

function lookAndSay($str) {

	return preg_replace_callback('#(.)\1*#', function($matches) {
	
		return strlen($matches[0]).$matches[1];
	}, $str);
}

$num = "1";

foreach(range(1,10) as $i) {

	echo $num."<br/>";
	$num = lookAndSay($num);
}

?>
