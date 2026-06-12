use v5.36;
use ntheory <fromdigits is_prime>;
use List::AllUtils <max firstidx>;

sub table ($c, @V) { my $t = $c * (my $w = 2 + length max @V); ( sprintf( ('%'.$w.'d')x@V, @V) ) =~ s/.{1,$t}\K/\n/gr }

my $max = 2500;
my @np = <4 6 8 9>;
for my $n (11..$max) {
    push @np, $n unless max map { max(split '',$n) < $_ and is_prime fromdigits($n,$_) } 2..$n;
}

say "First 50 pan-base composites:\n"                        . table 10, @np[0..49];
say "First 20 odd pan-base composites:\n"                    . table 10, (grep { 0 !=  $_ % 2 } @np)[0..19];
say "Count of pan-base composites up to and including $max: ". (my $f = 1 + firstidx { $max <= $_ } @np);
say "Percent odd  up to and including $max: "                . sprintf '%.3f', 100 * (grep { 0 != $_ % 2 } @np[0..$f-1]) / $f;
say "Percent even up to and including $max: "                . sprintf '%.3f', 100 * (grep { 0 == $_ % 2 } @np[0..$f-1]) / $f;
