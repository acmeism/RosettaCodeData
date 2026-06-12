use v5.36;
use List::Util <sum max>;

sub table ($c, @V) { my $t = $c * (my $w = 2 + length max @V); ( sprintf( ('%'.$w.'d')x@V, @V) ) =~ s/.{1,$t}\K/\n/gr }

my $upto = 1e6;
my @cons = (0) x $upto;
for my $i (1..$upto) {
    my $r = $i / sum split '', $i;
    $cons[$r] = 1 if $r eq int $r;
}
my @incons = grep { $cons[$_]==0 } 1..$#cons;

say 'First fifty inconsummate numbers (in base 10):';
say table 10, @incons[0..49];
say "One thousandth: " . $incons[999];
