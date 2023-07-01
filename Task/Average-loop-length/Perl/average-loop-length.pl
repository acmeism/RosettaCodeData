use List::Util qw(sum reduce);

sub find_loop {
    my($n) = @_;
    my($r,@seen);
    while () { $seen[$r] = $seen[($r = int(1+rand $n))] ? return sum @seen : 1 }
}

print " N    empiric      theoric      (error)\n";
print "===  =========  ============  =========\n";

my $MAX    = 20;
my $TRIALS = 1000;

for my $n (1 .. $MAX) {
    my $empiric = ( sum map { find_loop($n) } 1..$TRIALS ) / $TRIALS;
    my $theoric = sum map { (reduce { $a*$b } $_**2, ($n-$_+1)..$n ) / $n ** ($_+1) } 1..$n;

    printf "%3d  %9.4f  %12.4f   (%5.2f%%)\n",
            $n,  $empiric, $theoric, 100 * ($empiric - $theoric) / $theoric;
}
