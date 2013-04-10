<?php
$toggleState = array('open' => 'closed', 'closed' => 'open');
$doors = array_fill(1, 100, 'closed');
for ($pass = 1; $pass <= 100; ++$pass) {
	for ($nr = 1; $nr <= 100; ++$nr) {
		if ($nr % $pass == 0) {
			$doors[$nr] = $toggleState[$doors[$nr]];
		}
	}
}
for ($nr = 1; $nr <= 100; ++$nr)
	printf("Door %d is %s\n", $nr, $doors[$nr]);
?>
