<?php
for ($i = 1; $i <= 100; $i++) {
	$root = sqrt($i);
	$state = ($root == ceil($root)) ? 'open' : 'closed';
	echo "Door {$i}: {$state}\n";
}
?>
