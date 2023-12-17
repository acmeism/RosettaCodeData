use strict;
use warnings;
use feature <say current_sub>;
use experimental 'signatures';
use List::AllUtils <max head>;
use ntheory <is_square_free euler_phi>;
use Math::AnyNum <:overload idiv is_power iroot ipow is_coprime>;

sub table { my $t = shift() * (my $c = 1 + length max @_); (sprintf(('%' . $c . 'd') x @_, @_)) =~ s/.{1,$t}\K/\n/gr }

sub powerful_numbers ($n, $k = 2) {
    my @powerful;
    sub ($m, $r) {
        $r < $k and push @powerful, $m and return;
        for my $v (1 .. iroot(idiv($n, $m), $r)) {
            if ($r > $k) { next unless is_square_free($v) and is_coprime($m, $v) }
            __SUB__->($m * ipow($v, $r), $r - 1);
        }
    }->(1, 2 * $k - 1);
    sort { $a <=> $b } @powerful;
}

my (@achilles, %Ahash, @strong);
my @P = powerful_numbers(10**9, 2);
!is_power($_) and push @achilles, $_ and $Ahash{$_}++ for @P;
$Ahash{euler_phi $_} and push @strong, $_ for @achilles;

say "First 50 Achilles numbers:\n" . table 10,        head 50, @achilles;
say "First 30 strong Achilles numbers:\n" . table 10, head 30, @strong;
say "Number of Achilles numbers with:\n";

for my $l (2 .. 9) {
    my $c;
    $l == length and $c++ for @achilles;
    say "$l digits: $c";
}
