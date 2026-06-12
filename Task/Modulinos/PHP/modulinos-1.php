<?php
function meaning_of_life() {
	return 42;
}

function main($args) {
	echo "Main: The meaning of life is " . meaning_of_life() . "\n";
}

if (preg_match("/scriptedmain/", $_SERVER["SCRIPT_NAME"])) {
	main($argv);
}
?>
