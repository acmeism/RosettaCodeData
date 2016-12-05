constant modulus = 2**31;
sub bsd  {
    $^seed, ( 1103515245 * * + 12345 ) % modulus ... *
}
sub ms   {
    map * +> 16, (
	$^seed, ( 214013 * * + 2531011 ) % modulus ... *
    )
}

say 'BSD LCG first 10 values (first one is the seed):';
.say for bsd(0)[^10];

say "\nMS LCG first 10 values (first one is the seed):";
.say for ms(0)[^10];
