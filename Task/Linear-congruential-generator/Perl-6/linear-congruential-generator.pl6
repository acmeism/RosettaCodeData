my $mod = 2**31;
sub bsd ($seed) { ( 1103515245 * $seed + 12345   ) % $mod };
sub ms  ($seed) { ( 214013     * $seed + 2531011 ) % $mod };

say 'BSD LCG first 10 values:';
.say for ( 0.&bsd, -> $seed { $seed.&bsd } ... * )[^10];

say "\nMS LCG first 10 values:";
($_ +> 16).say for ( 0.&ms, -> $seed { $seed.&ms } ... * )[^10];
