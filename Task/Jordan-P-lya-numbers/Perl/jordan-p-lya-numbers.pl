use strict;
use warnings;
use feature 'say';

use ntheory 'factorial';
use List::AllUtils <max firstidx>;

sub table { my $t = 10 * (my $c = 1 + length max @_); ( sprintf( ('%'.$c.'d')x@_, @_) ) =~ s/.{1,$t}\K/\n/gr }

sub Jordan_Polya {
    my $limit = shift;
    my($k,@JP) = (2);
    push @JP, factorial $_ for 0..18;

    while ($k < @JP) {
        my $rk = $JP[$k];
        for my $l (2 .. @JP) {
            my $kl = $JP[$l] * $rk;
            last if $kl > $limit;
            LOOP: {
                my $p = firstidx { $_ >= $kl } @JP;
                if    ($p  < $#JP and $JP[$p] != $kl) { splice @JP, $p, 0, $kl }
                elsif ($p == $#JP                   ) {   push @JP,        $kl }
                $kl > $limit/$rk ? last LOOP : ($kl *= $rk)
            }
        }
        $k++
    }
    shift @JP; return @JP
}

my @JP = Jordan_Polya 2**27;
say "First 50 Jordan-Pólya numbers:\n" . table @JP[0..49];
say 'The largest Jordan-Pólya number before 100 million: ' . $JP[-1 + firstidx { $_ > 1e8 } @JP];
