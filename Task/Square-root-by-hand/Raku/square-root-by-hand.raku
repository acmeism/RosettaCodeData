# 20201023 Raku programming solution

sub integral   (Str $in) { # prepend '0' if length is odd
   given $in { .chars mod 2 ?? ('0'~$_).comb(2) !! .comb(2) }
}

sub fractional (Str $in) { # append  '0' if length is odd
   given $in { .chars mod 2 ?? ($_~'0').comb(2) !! .comb(2) }
}

sub SpigotSqrt ($in) {

   my @dividends, my @fractional; # holds digital duos
   my $d = 9;    # unit  digit part of divisors & running answer
   my $D = '';   # tens+ digit part of divisors
   my $dot_printed  = False;
   my $dividend; my $quotient = ''; my $remainder;

   return "Sorry, minimum charge is $0⁺" if $in ≤ 0;

   if $in.narrow ~~ Int {                 # integer
      @dividends = integral($in.Str)
   } else {
      given split(/\./, $in.Str) {        # floating point
         @dividends  =   integral(@_[0]);
         @fractional = fractional(@_[1]);
      }
   }

   $dividend = shift @dividends;

   loop {
      until ( $remainder = $dividend - ($D~$d) * $d ) ≥ 0 {
         $d-- # keep trying till the max divisor is found
      }
      print $d; # running answer
      $quotient ~= $d;
      unless @dividends.Bool {
         last if ( $remainder == 0 and $quotient != 0 and !@fractional.Bool );
         unless $dot_printed { print '.' and $dot_printed = True }
         if @fractional.Bool {      # happen only once
            @dividends.append: @fractional;
            @fractional = (); # retired
         } else {
            @dividends.append: '00';
         }
      }
      $dividend = $remainder.Str ~ shift @dividends;
      $D = 2*$quotient;
      $d = 9
   }
}

#`[ matches result from https://stackoverflow.com/a/28152047/3386748
for <99999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999982920000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000726067> { # ]
for < 25 0.0625 152.2756 13579.02468 > {
   say "The square root of $_ is";
   SpigotSqrt $_ ; print "\n";
}
