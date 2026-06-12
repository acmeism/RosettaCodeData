use v5.36;
use ntheory <is_prime vecmax vecany logint>;

sub comma { reverse ((reverse shift) =~ s/(.{3})/$1,/gr) =~ s/^,//r }
sub table ($c, @V) { my $t = $c * (my $w = 2 + vecmax map { length } @V); ( sprintf( ('%'.$w.'s')x@V, @V) ) =~ s/.{1,$t}\K/\n/gr }

my ($n, @D) = (3, 1);
while ($n++) {
    next unless $n % 2;
    next if vecany { is_prime($n - (1 << $_)) } reverse(1 .. logint($n, 2));
    push @D, comma $n;
    last if 10_000 == @D;
}

say "First fifty de Polignac numbers:\n" . table 10, @D[0..49];
say 'One thousandth: ' . $D[ 999];
say 'Ten thousandth: ' . $D[9999];
