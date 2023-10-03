my $elem-length = 8;
my @large of Str = ('a'..'z').roll($elem-length).join xx 10 * $worker * $BATCH-SIZE;

say "Benchmarking by sorting {@large.elems} strings of size $elem-length - using batches of $BATCH-SIZE strings and $worker workers.";
my @benchmark = gather for @implementations ->  &fun {
	&fun(@large);
	take (&fun.name => now - ENTER now);
}
say @benchmark;
