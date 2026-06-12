use strict;
use warnings;
use feature 'say';
use feature 'state';

use ntheory qw/fromdigits todigitstring/;

my $key = 'perl5';
srand fromdigits($key,36) % 2**63;

my @stream;

sub stream {
    my($i) = shift;
    state @chars;
    push @chars, chr($_) for 14..127;
    $stream[$i] = $chars[rand 1+127-14] unless $stream[$i];
}

sub jit_encode {
    my($str) = shift;
    my $i = 0;
    my $last = 0;
    my $enc = '';
    for my $c (split '', $str) {
        my $h;
        my $l = '';
        ++$i until $c eq stream($i);
        my $o = $i - $last;
        $l    = $o % 26;
        $h    = $o - $l if $o > 26;
        $l   += 10;
        $enc .= ($h ? uc todigitstring($h,36) : '') . lc todigitstring($l,36);
        $last = $i;
    }
    $enc
}

sub jit_decode {
    my($str) = shift;
    my @matches = $str =~ /((.*?) ([a-z]))/gx;
    my $dec = '';
    my $i = 0;
    for my $j (0 .. @matches/3 - 1) {
        my $o = ( fromdigits($matches[3*$j+1],36) - 10 // 0) +
                ( fromdigits($matches[3*$j+2],36)      // 0);
        $i   += $o;
        $dec .= $stream[$i];
    }
    $dec
}

my $enc = jit_encode('The slithey toves did gyre and gimble in the wabe');
say my $result = "Encoded\n$enc\n\nDecoded\n" . jit_decode($enc);
