# 20230721 Raku programming solution

my @primes = (2..1e7).grep: *.is-prime; # cannot do lazy here

sub median { # based on https://rosettacode.org/wiki/Averages/Median#Raku
   return { ( .[(*-1) div 2] + .[* div 2] ) / 2 }(@_) # for already sorted
}

sub isTetraPrime ($n is copy) { # is cached {
   my ($count,$prevFact) = 0, 1;
   for @primes -> \p {
      my $limit = p * p;
      if $count == 0 {
         $limit = $limit * $limit
      } elsif $count == 1 {
         $limit *= p
      }
      if $limit <= $n {
         while $n %% p {
            return False if ( $count == 4 or p == $prevFact );
            $count++;
            $n div= p;
            $prevFact = p
         }
      } else {
         last
      }
   }
   if $n > 1 {
      return False if ( $count == 4 or $n == $prevFact );
      $count++
   }
   return $count == 4
}

my ( $j, @tetras1, @tetras2, $sevens1, $sevens2 ) = 1e5;

my \highest7 = @primes.[*-1];
my \highest6 = @primes.first: * < 1e6, :end;
my \highest5 = @primes.first: * < 1e5, :end;

for @primes -> \p {
   if isTetraPrime p-1 and isTetraPrime p-2 {
      @tetras1.push: p;
      $sevens1++ if ( (p-1) %% 7 or (p-2) %% 7 );
   }
   if isTetraPrime p+1 and isTetraPrime p+2 {
      @tetras2.push: p;
      $sevens2++ if ( (p+1) %% 7 or (p+2) %% 7 );
   }
   if p == highest5 | highest6 | highest7 {
      for 0,1 -> \i {
         my (\sevens, \t, @tetras) := i == 0
            ?? ( $sevens1, "preceding", @tetras1 )
            !! ( $sevens2, "following", @tetras2 );
         my \c = @tetras.elems;

         say "Found {c} primes under $j whose {t} neighboring pair are tetraprimes:";
         if p == highest5 {
            say [~] $_>>.fmt('%6s') for @tetras.rotor(10,:partial);
         }
         say "of which {sevens} have a neighboring pair one of whose factors is 7.\n";
         my \gaps = ( @tetras.rotor(2=>-1).map: { .[1] - .[0] } ).sort;

         my (\Min,\Max,\Med) = gaps[0], gaps[*-1], median(gaps);
         say "Minimum gap between those {c} primes : {Min}";
         say "Median  gap between those {c} primes : {Med}";
         say "Maximum gap between those {c} primes : {Max}";
         say()
      }
      $j *= 10
   }
}
