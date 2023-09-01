# 20230719 Raku programming solution

my \factorials = 1, | [\*] 1..18; # with 0!

sub JordanPolya (\limit) {
   my \ix = (factorials.keys.first: factorials[*] >= limit) // factorials.end;
   my ($k, @res) = 2, |factorials[0..ix];

   while $k < @res.elems {
      my \rk = @res[$k];
      for 2 .. @res.elems -> \l {
         my \kl = $ = @res[l] * rk;
         last if kl > limit;
         loop {
            my \p = @res.keys.first: { @res[$_] >= kl } # performance
            if p < @res.elems and @res[p] != kl {
               @res.splice: p, 0, kl
            } elsif p == @res.elems {
               @res.append: kl
            }
            kl > limit/rk ?? ( last ) !! kl *= rk
         }
      }
      $k++
   }
   return @res[1..*]
}

my @result = JordanPolya 2**30 ;
say "First 50 Jordan-Pólya numbers:";
say [~] $_>>.fmt('%5s') for @result[^50].rotor(10);
print "\nThe largest Jordan-Pólya number before 100 million: ";
say @result.first: * < 100_000_000, :end;
