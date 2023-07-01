# 20210225 Raku programming solution

#!/usr/bin/env raku

class Padic { has ($.p is default(2), %.v is default({})) is rw ;

   method r2pa (Rat $x is copy, \p, \d) { # Reference: math.stackexchange.com/a/1187037
      self.p = p ;
      $x += p**d if $x < 0 ;  # complement

      my $lowerest = 0;
      my ($num,$den) = $x.nude;
      while ($den % p) == 0 { $den /= p and $lowerest-- }
      $x = $num / $den;

      while +self.v < d {
         my %d = ^p Z=> (( $x «-« ^p ) »/» p )».&{ .denominator % p }; # .kv
         for %d.keys { self.v.{$lowerest++} = $_ and last if %d{$_} != 0 }
         $x = ($x - self.v.{$lowerest-1}) / p ;
      }
      self
   }

   method add (Padic \x, \d) {
      my $div = 0;
      my $lowerest = (self.v.keys.sort({.Int}).first,
                         x.v.keys.sort({.Int}).first  ).min ;
      return Padic.new:
         p => self.p,
         v => gather for ^d {
            my $power = $lowerest + $_;
            given ((self.v.{$power}//0)+(x.v.{$power}//0)+$div).polymod(x.p)
               { take ($power, .[0]).Slip and $div = .[1] }
         }
   }

   method gist {
      # en.wikipedia.org/wiki/P-adic_number#Notation
      # my %H = (0..9) Z=> ('₀'..'₉'); # (0x2080 .. 0x2089);
      # '⋯ ' ~ self.v ~ ' ' ~ [~] self.p.comb».&{ %H{$_} }

      # express as a series
      my %H = ( 0…9 ,'-') Z=> ( '⁰','¹','²','³','⁴'…'⁹','⁻');
      [~] self.v.keys.sort({.Int}).map: {
         ' + ' ~ self.v.{$_} ~ '*' ~ self.p ~ [~] $_.comb».&{ %H{$_}} }
      }
}

my @T;
for my \D = (
#`[[ these are not working
   < 26/25 -109/125 5 4 >,
   < 6/7 -5/7 10 7 >,
   < 2/7 -3/7 10 7 >,
   < 2/7 -1/7 10 7 >,
   < 34/21 -39034/791 10 9 >,
#]]
#`[[[[[ Works
   < 11/4 679001/207 2 43>,
   < 11/4 679001/207 3 27 >,
   < 5/19 -101/384 2 12>,
   < -22/7 46071/379 7 13 >,
   < -7/5 99/70 7 4> ,
   < -101/109 583376/6649 61 7>,
   < 122/407 -517/1477 7 11>,

   < 2/1 1/1 2 4>,
   < 4/1 3/1 2 4>,
   < 4/1 3/1 2 5>,
   < 4/9 8/9 5 4>,
   < 11/4 679001/207 11 13 >,
   < 1/4 9263/2837 7 11 >,
   < 49/2 -4851/2 7 6 >,
   < -9/5 27/7 3 8>,
   < -22/7 46071/379 2 37 >,
   < -22/7 46071/379 3 23 >,

   < -101/109 583376/6649 2 40>,
   < -101/109 583376/6649 32749 3>,
   < -25/26 5571/137 7 13>,
#]]]]]

   < 5/8 353/30809 7 11 >,
) -> \D {
   given @T[0] = Padic.new { say D[0]~' = ', .r2pa: D[0],D[2],D[3] }
   given @T[1] = Padic.new { say D[1]~' = ', .r2pa: D[1],D[2],D[3] }
   given @T[0].add: @T[1], D[3] {
      given @T[2] = Padic.new { .r2pa: D[0]+D[1], D[2], D[3] }
      say "Addition result = ", $_.gist; #
      unless ( $_.v.Str eq @T[2].v.Str ) {
         say 'but ' ~ (D[0]+D[1]).nude.join('/') ~ ' = ' ~ @T[2].gist
      }
   }
}
