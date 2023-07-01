use utf8;
binmode STDOUT, "utf8:";
use Sort::Naturally;

sub triples {
    my($n,$angle) = @_;
    my(@triples,%sq);
    $sq{$_**2}=$_ for 1..$n;
    for $a (1..$n-1) {
      for $b ($a+1..$n) {
        my $ab = $a*$a + $b*$b;
        my $cos = $angle == 60  ? $ab - $a * $b :
                  $angle == 120 ? $ab + $a * $b :
                                  $ab;
        if ($angle == 60) {
            push @triples, "$a $sq{$cos} $b" if exists $sq{$cos};
        } else {
            push @triples, "$a $b $sq{$cos}" if exists $sq{$cos};
        }
      }
    }
    @triples;
}

$n = 13;
print "Integer triangular triples for sides 1..$n:\n";
for my $angle (120, 90, 60) {
   my @itt = triples($n,$angle);
   if ($angle == 60) { push @itt, "$_ $_ $_" for 1..$n }
   printf "Angle %3d° has %2d solutions: %s\n", $angle, scalar @itt,
         join ', ', nsort @itt;
}

printf "Non-equilateral n=10000/60°: %d\n", scalar triples(10000,60);
