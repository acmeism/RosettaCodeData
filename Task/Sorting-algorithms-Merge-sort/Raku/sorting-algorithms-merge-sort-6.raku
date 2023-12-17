use Benchmark;
my $runs = 5;
my $elems = 10 * Kernel.cpu-cores * 2**10;
my @unsorted of Str = ('a'..'z').roll(8).join xx $elems;
my UInt $l-batch = 2**13;
my UInt $m-batch = 2**11;
my UInt $s-batch = 2**9;
my UInt $t-batch = 2**7;

say "elements: $elems, runs: $runs, cpu-cores: {Kernel.cpu-cores}, large/medium/small/tiny-batch: $l-batch/$m-batch/$s-batch/$t-batch";

my %results = timethese $runs, {
	single-thread         => { mergesort(@unsorted) },
	parallel-naive        => { mergesort-parallel-naive(@unsorted) },
	parallel-tiny-batch   => { mergesort-parallel(@unsorted, $t-batch) },
	parallel-small-batch  => { mergesort-parallel(@unsorted, $s-batch) },
	parallel-medium-batch => { mergesort-parallel(@unsorted, $m-batch) },
	parallel-large-batch  => { mergesort-parallel(@unsorted, $l-batch) },
}, :statistics;

my @metrics = <mean median sd>;
my $msg-row = "%.4f\t" x @metrics.elems ~ '%s';

say @metrics.join("\t");
for %results.kv -> $name, %m {
	say sprintf($msg-row, %m{@metrics}, $name);
}
