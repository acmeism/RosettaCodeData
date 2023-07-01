<?php
$doors = array_fill(1, 100, false);
for ($pass = 1; $pass <= 100; ++$pass) {
	for ($nr = 1; $nr <= 100; ++$nr) {
		if ($nr % $pass == 0) {
			$doors[$nr] = !$doors[$nr];
		}
	}
}
for ($nr = 1; $nr <= 100; ++$nr)
	printf("Door %d: %s\n", $nr, ($doors[$nr])?'open':'closed');
?>
