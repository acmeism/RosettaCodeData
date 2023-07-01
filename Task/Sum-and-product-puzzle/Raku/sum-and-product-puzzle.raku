sub grep-unique (&by, @list) { @list.classify(&by).values.grep(* == 1).map(*[0]) }
sub sums        ($n)         { ($_, $n - $_ for 2 .. $n div 2) }
sub product     ([$x, $y])   { $x * $y }
sub sum         ([$x, $y])   { $x + $y }

my @all-pairs = (|($_ X $_+1 .. 98) for 2..97);

# Fact 1:
my %p-unique := Set.new: map ~*, grep-unique &product, @all-pairs;
my @s-pairs = @all-pairs.grep: { none (%p-unique{~$_} for sums sum $_) };

# Fact 2:
my @p-pairs = grep-unique &product, @s-pairs;

# Fact 3:
my @final-pairs = grep-unique &sum, @p-pairs;

printf "X = %d, Y = %d\n", |$_ for @final-pairs;
