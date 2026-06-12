use strict;
use warnings;
use List::AllUtils 'firstidx';
use Lingua::EN::Numbers qw(num2en);

my $limit = 1 + int 5e6 / 8;
my @f = map { $_*8 - 1 } 1..$limit;

my($p0,$p1, @F) = (1,0, $f[0]);
do {
    push @F, ($f[$p0] < $F[$p1]*4) ? $f[$p0++] : $F[$p1++]*4;
} until $p0 == $limit or $p1 == $limit;

printf "First %s forbidden numbers:\n", num2en 50;
print sprintf(('%4d')x50, @F[0..49]) =~ s/.{40}\K(?=.)/\n/gr;
print "\n\n";

for my $x (5e2, 5e3, 5e4, 5e5, 5e6) {
    printf "%6d = forbidden number count up to %s\n", (firstidx { $_ > $x } @F), num2en($x);
}
