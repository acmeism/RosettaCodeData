# SYNTHETICS HANDLING
my @synth = flat < b d f j k n p r s t w > X~ < a e i o u >;
my %htnys = @synth.antipairs;
my $exp   = @synth.elems;
my $prec  = 100_000;


sub synth (Int $v) { @synth[$v.polymod($exp xx *).reverse || 0].join }

sub thnys (Str $v) { sum %htnys{$v.comb(2).reverse} Z× 1, $exp, $exp² }


# ENCODE / DECODE
sub w-encode ( Rat(Real) $lat, Rat(Real) $lon, :&f = &synth ) {
    $_ = (($lat +  90) × $prec).round.fmt('%025b') ~ (($lon + 180) × $prec).round.fmt('%026b');
    (:2(.substr(0,17)), :2(.substr(17,17)), :2(.substr(34)))».&f
}

sub w-decode ( *@words, :&f = &thnys ) {
    my $bin = @words».&f.map({.fmt('%017b')}).join;
    (:2($bin.substr(0,25))/$prec) - 90, (:2($bin.substr(25))/$prec) - 180
}


# TESTING
for 51.43372,  -0.21412, # Wimbledon center court
    21.25976,-157.81173, # Diamond Head summit
   -55.96525, -67.22557, # Monumento Cabo De Hornos
    28.3852,  -81.5638,  # Walt Disney World
    89.99999, 179.99999, # test some
   -89.99999,-179.99999  # extremes
  -> $lat, $lon {
    my @words = w-encode $lat, $lon;
    printf "Coordinates: %s, %s\n   To Index: %s\n  To 3-word: %s\nFrom 3-word: %s, %s\n\n",
      $lat, $lon, w-encode($lat, $lon, :f({$_})).Str, @words.Str, w-decode(@words);
}
