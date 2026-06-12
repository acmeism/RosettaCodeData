# 20240210 Raku programming solution

sub convergents(Real $x is copy, Int $maxcount) {
   my @components = gather for ^$maxcount {
      my $fpart = $x - take $x.Int;
      $fpart == 0 ?? ( last ) !! ( $x = 1 / $fpart )
   }
   my ($numa, $denoma, $numb, $denomb) = 1, 0, @components[0], 1;
   return [ Rat.new($numb, $denomb) ].append: gather for @components[1..*] -> $comp {
      ( $numa, $denoma, $numb                , $denomb                  )
      = $numb, $denomb, $numa + $comp * $numb, $denoma + $comp * $denomb;
      take Rat.new($numb, $denomb);
   }
}

my @tests = [ "415/93", 415/93, "649/200", 649/200, "sqrt(2)", sqrt(2),
              "sqrt(5)", sqrt(5), "golden ratio", (sqrt(5) + 1) / 2     ];

say "The continued fraction convergents for the following (maximum 8 terms) are:";
for @tests -> $s, $x {
   say $s.fmt('%15s') ~ " = { convergents($x, 8).map: *.nude.join('/') } ";
}
