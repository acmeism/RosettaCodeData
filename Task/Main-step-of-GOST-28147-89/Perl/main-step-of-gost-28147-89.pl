use strict;
use warnings;
use ntheory 'fromdigits';

# sboxes from http://en.wikipedia.org/wiki/GOST_(block_cipher)
my @sbox = (
    [4, 10, 9, 2, 13, 8, 0, 14, 6, 11, 1, 12, 7, 15, 5, 3],
    [14, 11, 4, 12, 6, 13, 15, 10, 2, 3, 8, 1, 0, 7, 5, 9],
    [5, 8, 1, 13, 10, 3, 4, 2, 14, 15, 12, 7, 6, 0, 9, 11],
    [7, 13, 10, 1, 0, 8, 9, 15, 14, 4, 6, 12, 11, 2, 5, 3],
    [6, 12, 7, 1, 5, 15, 13, 8, 4, 10, 9, 14, 0, 3, 11, 2],
    [4, 11, 10, 0, 7, 2, 1, 13, 3, 6, 8, 5, 9, 12, 15, 14],
    [13, 11, 4, 1, 3, 15, 5, 9, 0, 10, 14, 7, 6, 8, 2, 12],
    [1, 15, 13, 0, 5, 7, 10, 4, 9, 2, 3, 14, 6, 11, 8, 12]
);

sub rol32 {
    my($y, $n) = @_;
    ($y << $n) % 2**32 | ($y >> (32 - $n))
}

sub GOST_round {
    my($R, $K) = @_;
    my $a = ($R + $K) % 2**32;
    my $b = fromdigits([map { $sbox[$_][($a >> (4*$_))%16] } reverse 0..7],16);
    rol32($b,11);
}

sub feistel_step {
    my($F, $L, $R, $K) = @_;
    $R, $L ^ &$F($R, $K)
}

my @input = (0x21, 0x04, 0x3B, 0x04, 0x30, 0x04, 0x32, 0x04);
my @key   = (0xF9, 0x04, 0xC1, 0xE2);

my $R = fromdigits([reverse @input[0..3]], 256); # 1st half
my $L = fromdigits([reverse @input[4..7]], 256); # 2nd half
my $K = fromdigits([reverse @key        ], 256);

($L,$R) = feistel_step(\&GOST_round, $L, $R, $K);

printf '%02X ', (($L << 32) + $R >> (8*$_))%256 for 0..7;
print "\n";
