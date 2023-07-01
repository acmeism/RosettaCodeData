use Prime::Factor;

my @factor-sum;

@factor-sum[1000000] = 42; # Sink a large index to make access thread safe

sub rhonda ($base) {
    (1..∞).hyper.map: { $_ if $base * (@factor-sum[$_] //= .&prime-factors.sum) == [×] .polymod($base xx *) }
}

for (flat 2..16, 17..36).grep: { !.&is-prime }  -> $b {
    put "\nFirst 15 Rhonda numbers to base $b:";
    my @rhonda = rhonda($b)[^15];
    my $ch = @rhonda[*-1].chars max @rhonda[*-1].base($b).chars;
    put "In base 10: " ~ @rhonda».fmt("%{$ch}s").join: ', ';
    put $b.fmt("In base %2d: ") ~ @rhonda».base($b)».fmt("%{$ch}s").join: ', ';
}
