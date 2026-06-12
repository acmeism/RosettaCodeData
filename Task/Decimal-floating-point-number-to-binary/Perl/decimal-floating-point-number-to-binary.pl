use strict;
use warnings;
use feature 'say';

sub dec2bin {
    my($l,$r) = split /\./, shift;
    my $int  = unpack('B*',  pack('N',               $l ));
    my $frac = unpack('B32', pack('N',4294967296 * ".$r"));
    "$int.$frac" =~ s/^0*(.*?)0*$/$1/r;
}

sub bin2dec {
    my($l,$r) = split /\./, shift;
    my $frac = my $i = 0;
    --$i, $frac += $_ * 2**$i for split '', $r;
    eval('0b'.$l) + $frac;
}

say dec2bin(23.34375);
say bin2dec('1011.11101');
