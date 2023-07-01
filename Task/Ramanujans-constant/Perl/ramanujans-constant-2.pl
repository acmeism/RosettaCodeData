use strict;
use Math::AnyNum <as_dec rat>;

sub continued_fr {
    my ($a, $b, $n) = (@_[0,1], $_[2] // 100);
    $a->() + ($n && $b->() / continued_fr($a, $b, $n-1));
}

my $r163 = continued_fr do {my $n; sub {$n++ ? 2*12 : 12 }},        do {my $n; sub { rat 19 }}, 40;
my $pi   = continued_fr do {my $n; sub {$n++ ? 1 + 2*($n-2) : 0 }}, do {my $n; sub { rat($n++ ? ($n>2 ? ($n-1)**2 : 1) : 4)}}, 140;
my $p    = $pi * $r163;
my $R    = 1 + $p / continued_fr do { my $n; sub { $n++ ? $p+($n+0) : 1 } }, do {my $n; sub { $n++; -1*$n*$p }}, 180;

printf "Ramanujan's constant\n%s\n", as_dec($R,58);
