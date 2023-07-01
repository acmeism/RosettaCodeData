use strict;
use warnings;
use feature 'say';
use ntheory qw<primes>;
use List::Util qw<min>;

#use bigint     # works, but slow
use Math::GMPz; # this module gives roughly 16x speed-up

sub smooth_numbers {
#    my(@m) = @_;                               # use with 'bigint'
    my @m = map { Math::GMPz->new($_) } @_;     # comment out to NOT use Math::GMPz
    my @s;
    push @s, [1] for 0..$#m;

    return sub {
    my $n = $s[0][0];
    $n = min $n, $s[$_][0] for 1..$#m;
    for (0..$#m) {
            shift @{$s[$_]} if $s[$_][0] == $n;
            push @{$s[$_]}, $n * $m[$_]
        }
        return $n
    }
}

sub abbrev {
    my($n) = @_;
    return $n if length($n) <= 50;
    substr($n,0,10) . "...(@{[length($n) - 2*10]} digits omitted)..." . substr($n, -10, 10)
}

my @primes = @{primes(10_000)};

my $start = 3000; my $cnt = 3;
for my $n_smooth (0..9) {
    say "\nFirst 25, and ${start}th through @{[$start+2]}nd $primes[$n_smooth]-smooth numbers:";
    my $s = smooth_numbers(@primes[0..$n_smooth]);
    my @S25;
    push @S25, $s->() for 1..25;
    say join ' ', @S25;

    my @Sm; my $c = 25;
    do {
        my $sn = $s->();
        push @Sm, abbrev($sn) if ++$c >= $start;
    } until @Sm == $cnt;
    say join ' ', @Sm;
}

$start = 30000; $cnt = 20;
for my $n_smooth (95..97) { # (503, 509, 521) {
    say "\n${start}th through @{[$start+$cnt-1]}th $primes[$n_smooth]-smooth numbers:";
    my $s = smooth_numbers(@primes[0..$n_smooth]);
    my(@Sm,$c);
    do {
        my $sn = $s->();
        push @Sm, $sn if ++$c >= $start;
    } until @Sm == $cnt;
    say join ' ', @Sm;
}
