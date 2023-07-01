use strict;
use warnings;
use ntheory 'divisor_sum';

sub comma { reverse ((reverse shift) =~ s/(.{3})/$1,/gr) =~ s/^,//r }

sub chowla {
    my($n) = @_;
    $n < 2 ? 0 : divisor_sum($n) - ($n + 1);
}

sub prime_cnt {
    my($n) = @_;
    my $cnt = 1;
    for (3..$n) {
        $cnt++ if $_%2 and chowla($_) == 0
    }
    $cnt;
}

sub perfect {
    my($n) = @_;
    my @p;
    for my $i (1..$n) {
        push @p, $i if $i > 1 and chowla($i) == $i-1;
    }
    # map { push @p, $_ if $_ > 1 and chowla($_) == $_-1 } 1..$n; # speed penalty
    @p;
}

printf "chowla(%2d) = %2d\n", $_, chowla($_) for 1..37;
print "\nCount of primes up to:\n";
printf "%10s %s\n", comma(10**$_), comma(prime_cnt(10**$_)) for 2..7;
my @perfect = perfect(my $limit = 35_000_000);
printf "\nThere are %d perfect numbers up to %s: %s\n",
    1+$#perfect, comma($limit), join(' ', map { comma($_) } @perfect);
