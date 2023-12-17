use v5.36;
use ntheory qw(is_square is_semiprime factor vecall);

sub comma          { reverse((reverse shift) =~ s/.{3}\K/,/gr)                      =~ s/^,//r }
sub table ($c, @V) { my $t = $c * (my $w = 5); (sprintf(('%' . $w . 'd') x @V, @V)) =~ s/.{1,$t}\K/\n/gr }

sub is_blum ($n) {
    ($n % 4) == 1 && is_semiprime($n) && !is_square($n) && vecall { ($_ % 4) == 3 } factor($n);
}

my @nth = (26828, 1e5, 2e5, 3e5, 4e5);

my (@blum, %C);
for (my $i = 1 ; ; ++$i) {
    push @blum, $i if is_blum $i;
    last if $nth[-1] == @blum;
}
$C{$_ % 10}++ for @blum;

say "The first fifty Blum integers:\n" . table 10, @blum[0 .. 49];
printf "The %7sth Blum integer: %9s\n", comma($_), comma $blum[$_ - 1] for @nth;
say '';
printf "$_: %6d (%.3f%%)\n", $C{$_}, 100 * $C{$_} / scalar @blum for <1 3 7 9>;
