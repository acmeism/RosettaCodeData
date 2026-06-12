# SYNTHETICS HANDLING
my @synth = flat < b d f h j k l m n p r s t w y z > X~ < a e i o u >;
my %htnys = @synth.antipairs;
my $exp   = @synth.elems;

sub synth (Int $v) { @synth[($v + (^18).pick * 28126).polymod($exp xx *).reverse || 0].join }

sub thnys (Str $v) { (sum %htnys{$v.comb(2).reverse} Z* 1, $exp, $exp**2) % 28126 }


# ENCODE / DECODE
sub w-encode ( Rat(Real) $lat, Rat(Real) $lon, :&f = &synth ) {
    $_ = (($lat +  90) * 10000).round.fmt('%021b') ~ (($lon + 180) * 10000).round.fmt('%022b');
    (:2(.substr(0,15)), :2(.substr(15,14)),:2(.substr(29)))».&f
}

sub w-decode ( *@words, :&f = &thnys ) {
    my $bin = (@words».&f Z, <0 1 1>).map({.[0].fmt('%015b').substr(.[1])}).join;
    (:2($bin.substr(0,21))/10000) - 90, (:2($bin.substr(21))/10000) - 180
}


# TESTING
for 51.4337,  -0.2141, # Wimbledon
    21.2596,-157.8117, # Diamond Head crater
   -55.9652, -67.2256, # Monumento Cabo De Hornos
    59.3586,  24.7447, # Lake Raku
    29.2021,  81.5324, # Village Raku
    -7.1662,  53.9470, # The Indian ocean, south west of Seychelles
    28.3852, -81.5638  # Walt Disney World
  -> $lat, $lon {
    my @words = w-encode $lat, $lon;
    my @index = w-encode $lat, $lon, :f( { $_ } );
    printf "Coordinates: %s, %s\n   To Index: %s\n  To 3-word: %s\nFrom 3-word: %s, %s\n From Index: %s, %s\n\n",
      $lat, $lon, @index.Str, @words.Str, w-decode(@words), w-decode @index, :f( { $_ } );
}
