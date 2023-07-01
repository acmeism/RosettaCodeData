my @bases = <A C G T>;

# The DNA strand
my $dna = @bases.roll(200).join;


# The Task
put "ORIGINAL DNA STRAND:";
put pretty $dna;
put "\nTotal bases: ", +my $bases = $dna.comb.Bag;
put $bases.sort( ~*.key ).join: "\n";

put "\nMUTATED DNA STRAND:";
my $mutate = $dna.&mutate(10);
put pretty diff $dna, $mutate;
put "\nTotal bases: ", +my $mutated = $mutate.comb.Bag;
put $mutated.sort( ~*.key ).join: "\n";


# Helper subs
sub pretty ($string, $wrap = 50) {
    $string.comb($wrap).map( { sprintf "%8d: %s", $++ * $wrap, $_ } ).join: "\n"
}

sub mutate ($dna is copy, $count = 1) {
    $dna.substr-rw((^$dna.chars).roll, 1) = @bases.roll for ^$count;
    $dna
}

sub diff ($orig, $repl) {
    ($orig.comb Z $repl.comb).map( -> ($o, $r) { $o eq $r ?? $o !! $r.lc }).join
}
