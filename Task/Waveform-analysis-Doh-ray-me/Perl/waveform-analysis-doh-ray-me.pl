# 20200808 added Perl programming solution

use v5.10;
use strict;
use warnings;
use autodie;

use Math::Trig;
use List::Util qw/sum/;
use constant PI => 4 * atan2(1, 1);

my @freqs = qw ( 261.6 293.6 329.6 349.2 392.0 440.0 493.9 523.3 );
my @notes = qw ( Doh Ray Mee Fah Soh Lah Tee doh );

sub getNote {
   my $freq  = $_[0];
   my $index = @freqs;
   for (0..$index-1) { $index = $_ and last if $freq <= $freqs[$_] }
   given ($index) {
      when (0)      { "Doh-" }
      when (@freqs) { "doh+" }
      default       { $freqs[$index] - $freq <= $freq - $freqs[$index-1]
                         ? $notes[$index] . "-" : $notes[$index-1] . "+" }
   }
}


open my $fh, '<:raw', './notes.wav';

# http://www.topherlee.com/software/pcm-tut-wavformat.html

read $fh, my $header, 28;
print "Sample Rate    : ", my $sampleRate = unpack(' x24 L< ', $header), "\n" ;

read $fh, $header, 16;
my $dataLength = unpack(' x12 L< ', $header);
print "Duration       : ", my $duration = $dataLength / $sampleRate, "\n";

my ( $sum, $nbytes )  =  ( 0, 20 ) ;

print "Bytes examined : $nbytes per sample\n";

while ( read $fh, my $data, $sampleRate ) {
   my @chunk = split('', $data);
   for my $k (1..$nbytes) {
      my $bf = ord($chunk[$k]) / 32;
      $sum += asin($bf) * $sampleRate / ( 2 * PI * $k );
   }
}

close $fh;

my $cav = $sum / ( $duration * $nbytes );
printf "Computed average frequency = %.1f", $cav;
print  " Hz (",getNote($cav),")\n";

my $aav = sum(@freqs) / @freqs;
printf "Actual   average frequency = %.1f", $aav;
print  " Hz (",getNote($aav),")\n";
