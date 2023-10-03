use Test;
my @testcases =
		() => (),
		<a>.List => <a>.List,
		<a a> => <a a>,
		<a b> => <a b>,
		<b a> => <a b>,
		<h b a c d f e g> => <a b c d e f g h>,
		(2, 3, 1, 4, 5) => (1, 2, 3, 4, 5),
		<a 🎮 3 z 4 🐧> => <a 🎮 3 z 4 🐧>.sort
		;
my @implementations = &mergesort, &mergesort-parallel, &mergesort-parallel-naive;
plan @testcases.elems * @implementations.elems;
for @implementations ->  &fun {
	say &fun.name;
	is-deeply &fun(.key), .value, .key ~ "  =>  " ~ .value for @testcases;
}
done-testing;

use Benchmark;
my $elem-length = 8;
my @unsorted of Str = ('a'..'z').roll($elem-length).join xx 10 * $worker * $BATCH-SIZE;
my $runs = 10;

say "Benchmarking by $runs times sorting {@unsorted.elems} strings of size $elem-length - using batches of $BATCH-SIZE strings and $worker workers for mergesort-parallel().";
say "Hint: watch the number of Raku threads in Activity Monitor on Mac, Ressource Monitor on Windows or htop on Linux.";
for @implementations ->  &fun {
	print &fun.name, " => avg: ";
	my ($start, $end, $diff, $avg) = timethis $runs, sub { &fun(@unsorted) }
	say "$avg secs, total $diff secs";
}
