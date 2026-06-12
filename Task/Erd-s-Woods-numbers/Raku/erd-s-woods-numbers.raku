# 20220308 Raku programming solution

sub ew (\n) {

   my @primes = (^n).grep: *.is-prime;

   # rosettacode.org/wiki/Horner%27s_rule_for_polynomial_evaluation#Raku
   my @divs = (^n).map: -> \p { ([o] map { p%%$_.Int + 2 * * }, @primes)(0) }

   my @partitions = [ 0, 0, 2**@primes.elems - 1 ] , ;

   sub ort(\x) { (@divs[x] +| @divs[n -x]).base(2).flip.index(1) }

   for ((n^...1).sort: *.&ort).reverse {
      my \newPartitions = @ = ();
      my (\factors,\otherFactors) = @divs[$_, n-$_];

      for @partitions -> \p {
         my (\setA, \setB, \rPrimes) = p[0..2];

         if (factors +& setA) or (otherFactors +& setB) {
            newPartitions.push: p and next
         }
         for (factors +& rPrimes).base(2).flip.comb.kv -> \k,\v {
            if (v == 1) {
               my \w = 1 +< k;
               newPartitions.push: [ setA +^ w, setB, rPrimes +^ w ]
            }
         }
         for (otherFactors +& rPrimes).base(2).flip.comb.kv -> \k,\v {
            if (v == 1) {
               my \w = 1 +< k;
               newPartitions.push: [ setA, setB +^ w, rPrimes +^ w ]
            }
         }
      }
      @partitions = newPartitions
   }

   my \result = $ = -1;
   for @partitions -> \p {
      my ($px,$py,$x,$y) = p[0],p[1],1,1;
      for @primes -> $p {
         $px % 2 and $x *= $p;
         $py % 2 and $y *= $p;
         ($px,$py) >>div=>> 2
      }
      my \newresult = ((n * expmod($x, -1, $y)) % $y) * $x - n;
      result = result == -1 ?? newresult !! min(result, newresult)
   }
   return result
}

say "The first 20 Erdős–Woods numbers and their minimum interval start values are:";
for (16..116) { if (my $ew = ew $_) > 0 { printf "%3d -> %d\n",$_,$ew } } ;
