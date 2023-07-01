use strict;
use warnings;
use feature 'say';
use integer; # required solely for 2's complement operation: $n1 = ~$n2

sub own_password {
    my($password, $nonce) = @_;
    my $n1 = 0;
    my $n2 = $password;
    for my $d (split //, $nonce) {
        if      ($d == 1) {
            $n1   = ($n2 & 0xFFFFFF80) >> 7;
            $n2 <<= 25;
        } elsif ($d == 2) {
            $n1   = ($n2 & 0xFFFFFFF0) >> 4;
            $n2 <<= 28;
        } elsif ($d == 3) {
            $n1   = ($n2 & 0xFFFFFFF8) >> 3;
            $n2 <<= 29;
        } elsif ($d == 4) {
            $n1   = $n2 << 1;
            $n2 >>= 31;
        } elsif ($d == 5) {
            $n1   = $n2 << 5;
            $n2 >>= 27;
        } elsif ($d == 6) {
            $n1   = $n2 << 12;
            $n2 >>= 20;
        } elsif ($d == 7) {
            $n1 = ($n2 & 0x0000FF00) | (($n2 & 0x000000FF) << 24) | (($n2 & 0x00FF0000) >> 16);
            $n2 = ($n2 & 0xFF000000) >> 8;
        } elsif ($d == 8) {
            $n1 = ($n2 & 0x0000FFFF) << 16 | $n2 >> 24;
            $n2 = ($n2 & 0x00FF0000) >> 8;
        } elsif ($d == 9) {
            $n1 = ~$n2;
        } else {
            $n1 = $n2
        }
        $n1 = ($n1 | $n2) & 0xFFFFFFFF if $d != 0 and $d != 9;
        $n2 = $n1;
    }
    $n1
}

say own_password( 12345, 603356072 );
say own_password( 12345, 410501656 );
say own_password( 12345, 630292165 );
