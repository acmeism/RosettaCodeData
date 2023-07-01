use strict;
use warnings;
use feature 'say';
use ntheory 'is_prime';
use List::MoreUtils qw(zip slideatatime);
use Algorithm::Combinatorics qw(permutations);

say '1 2';

my @count = (0, 0, 1);

for my $n (3..17) {
    my @even_nums = grep { 0 == $_ % 2 } 2..$n-1;
    my @odd_nums  = grep { 1 == $_ % 2 } 3..$n-1;
    for my $e (permutations [@even_nums]) {
        next if $$e[0] == 8 or $$e[0] == 14;
        my $nope = 0;
        for my $o (permutations [@odd_nums]) {
            my @list = (zip(@$e, @$o), $n);                 # 'zip' makes a list with a gap if more evens than odds
            splice @list, -2, -1 if not defined $list[-2];  # in which case splice out 'undef' in next-to-last position
            my $it = slideatatime(1, 2, @list);
            while ( my @rr = $it->() ) {
                last unless defined $rr[1];
                $nope++ and last unless is_prime $rr[0]+$rr[1];
            }
            unless ($nope) {
                say '1 ' . join ' ', @list unless $count[$n];
                $count[$n]++;
            }
            $nope = 0;
        }
    }
}

say "\n" . join ' ', @count[2..$#count];
