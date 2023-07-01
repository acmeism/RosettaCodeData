use strict;
use warnings;
use feature 'say';
use List::AllUtils <max head firstidx uniqint>;
use ntheory <primes is_semiprime forsetproduct>;

sub table { my $t = shift() * (my $c = 1 + length max @_); ( sprintf( ('%'.$c.'d')x@_, @_) ) =~ s/.{1,$t}\K/\n/gr }
sub comma { reverse ((reverse shift) =~ s/(.{3})/$1,/gr) =~ s/^,//r }

my(@B,@Br);
for my $oom (1..5) {
    my @P = grep { $oom == length } @{primes(10**$oom)};
    forsetproduct { is_semiprime($_[0] * $_[1]) and push @B, $_[0] * $_[1] } \@P, \@P;
    @Br = uniqint sort { $a <=> $b } @Br, @B;
}

say "First 100 brilliant numbers:\n" . table 10, head 100, @Br;

for my $oom (1..9) {
    my $key = firstidx { $_ > 10**$oom } @Br;
    printf "First >= %13s is position %9s in the series: %13s\n", comma(10**$oom), comma($key), comma $Br[$key];
}
