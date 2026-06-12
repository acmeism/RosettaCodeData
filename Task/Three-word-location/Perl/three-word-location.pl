use strict;
use warnings;
use feature 'say';
use bignum; # without this, round-trip results not exact

use Math::AnyNum 'polymod';

# SYNTHETICS HANDLING

my @synth;
push @synth, join '', @$_ for map { [split /:/] } glob '{b,d,f,h,j,k,l,m,n,p,r,s,t,w,y,z}:{a,e,i,o,u}';
my(%htnys,$c); $htnys{$_} = $c++ for @synth;
my $exp  = @synth;
my $prec = 10_000;

sub bin2dec { unpack('N', pack('B32', substr('0' x 32 . shift, -32))) }

sub synth { join '', reverse @synth[polymod(shift() + int(rand 18) * 28126, $exp, $exp) ] }

sub thnys {
    my @n = @htnys{ shift() =~ /(..)(..)(..)/ };  # NB notation on hash slice: % -> @
    ($n[2] + $n[1]*$exp + $n[0]*$exp**2) % 28126
}

# ENCODE / DECODE

sub w_encode {
    my($lat, $lon, $f) = @_;
    $f = \&synth unless $f;
    my @words;
    my $bits = sprintf '%021b%022b', int(($lat+90)*$prec), int(($lon+180)*$prec);
    push @words, &$f(bin2dec($_)) for $bits =~ / (.{15}) (.{14}) (.{14}) /x;
    @words
}

sub w_decode {
    my($w, $f) = @_;
    $f = \&thnys unless $f;
    my $s = '%015b';
    my $bin = sprintf($s, &$f($$w[0])) . substr(sprintf($s, &$f($$w[1])), 1) . substr(sprintf($s, &$f($$w[2])), 1);
    (bin2dec(substr($bin,0,21))/$prec - 90), (bin2dec(substr($bin,21))/$prec - 180)
}

# TESTING

for ([ 51.4337,     -0.2141,   'Wimbledon'],
     [ 21.2596,   -157.8117,   'Diamond Head crater'],
     [-55.9652,    -67.2256,   'Monumento Cabo De Hornos'],
     [ 71.170924,   25.782998, 'Nordkapp, Norway'],
     [ 45.762983,    4.834520, 'Café Perl, Lyon'],
     [ 48.391541, -124.736731, 'Cape Flattery Lighthouse, Tatoosh Island'],
    ) {
    my($lat, $lon, $description) = @$_;
    my @words = w_encode $lat, $lon;
    my @index = w_encode $lat, $lon, sub { shift };
    printf "Coordinates: %s, %s (%s)\n   To Index: %s\n  To 3-word: %s\nFrom 3-word: %s, %s\n From Index: %s, %s\n\n",
      $lat, $lon, $description, join(' ',@index), join(' ',@words), w_decode(\@words), w_decode(\@index, sub { shift() });
}
