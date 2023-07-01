# 20211124 Raku programming solution

sub gamma (\N where N > 1) { # Vacca series https://w.wiki/4ybp
                             # convert terms to FatRat for arbitrary precision
   return  (1/2 - 1/3) + [+] (2..N).race.map: -> \n {

      my ($power, $sign, $term) = 2**n, -1;

      for ($power..^2*$power) { $term += ($sign = -$sign) / $_ }

      n*$term
   }
}

say gamma 23 ;
