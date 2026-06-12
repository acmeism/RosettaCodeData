# 20230602 Raku programming solution

sub undulating ($base, \n) {
   my \limit = 2**(my \mpow = 53) - 1;
   my (\bsquare,@u3,@u4) = $base*$base;
   for 1..^$base X 0..^$base -> (\a,\b) {
      next if b == a;
      @u3.push(a * bsquare + b * $base + a);
      @u4.push((my \v = a * $base + b) * bsquare + v)
   }
   say "\nAll 3 digit undulating numbers in base $base:";
   .fmt('%3d').say for @u3.rotor: 9;
   say "\nAll 4 digit undulating numbers in base $base:";
   .fmt('%4d').say for @u4.rotor: 9;
   say "\nAll 3 digit undulating numbers which are primes in base $base:";
   my @primes = @u3.grep: *.is-prime;
    .fmt('%3d').say for @primes.rotor: 10, :partial;
   my \unc = (my @un = @u3.append: @u4).elems;
   my ($j, $done) = 0, False;
   loop {
      for 0..^unc {
         my  \u = @un[$j * unc + $_] * bsquare + @un[$j * unc + $_] % bsquare;
	 u > limit ?? ( $done = True and last ) !! ( @un.push: u );
      }
      $done ?? ( last ) !! $j++
   }
   say "\nThe {n} undulating number in $base $base is: @un[n-1]";
   say "or expressed in base $base : {@un[n-1].base($base)}" unless $base == 10;
   say "\nTotal number of undulating numbers in base $base < 2**{mpow} = {+@un}";
   say "of which the largest is: ", @un[*-1];
   say "or expressed in base $base : {@un[*-1].base($base)}" unless $base == 10;
}

undulating $_, 600 for 10, 7;
