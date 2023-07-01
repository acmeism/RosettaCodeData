use strict;
use warnings;
use feature 'say';
use ntheory 'is_prime';
use enum qw(False True);

sub comma { reverse ((reverse shift) =~ s/(.{3})/$1,/gr) =~ s/^,//r }

sub is_unprimeable {
    my($n) = @_;
    return False if is_prime($n);
    my $chrs = length $n;
    for my $place (0..$chrs-1) {
        my $pow = 10**($chrs - $place - 1);
        my $this = substr($n, $place, 1) * $pow;
        map { return False if $this != $_ and is_prime($n - $this + $_ * $pow) } 0..9;
     }
     True
}

my($n, @ups);
do { push @ups, $n if is_unprimeable(++$n); } until @ups == 600;
say "First 35 unprimeables:\n" . join ' ', @ups[0..34];
printf "\n600th unprimeable: %s\n", comma $ups[599];

map {
    my $x = $_;
    while ($x += 10) { last if is_unprimeable($x) }
    say "First unprimeable that ends with $_: " . sprintf "%9s", comma $x;
} 0..9;
