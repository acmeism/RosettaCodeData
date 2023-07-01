<?php

$bottles = 99;

while ($bottles > 0) {
	printf(ngettext('%d bottle', '%d bottles', $bottles) . " of beer on the wall\n", $bottles);		//X bottles of beer on the wall
	printf(ngettext('%d bottle', '%d bottles', $bottles) . " of beer\n", $bottles);				//X bottles of beer
	printf("Take one down, pass it around\n");										//Take one down, pass it around

	$bottles--;

	if ($bottles > 0) {
		printf(ngettext('%d bottle', '%d bottles', $bottles) . " of beer on the wall\n\n", $bottles);	//X bottles of beer on the wall
	}
}
printf('No more bottles of beer on the wall');											//No more bottles of beer on the wall
