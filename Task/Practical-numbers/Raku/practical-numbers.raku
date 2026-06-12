use Prime::Factor:ver<0.3.0+>;

sub is-practical ($n) {
   return True  if $n == 1;
   return False if $n % 2;
   my @proper = $n.&proper-divisors :sort;
   return True if all( @proper.rotor(2 => -1).map: { .[0] / .[1] >= .5 } );
   my @proper-sums = @proper.combinations».sum.unique.sort;
   +@proper-sums < $n-1 ?? False !! @proper-sums[^$n] eqv (^$n).list ?? True !! False
}

say "{+$_} matching numbers:\n{.batch(10)».fmt('%3d').join: "\n"}\n"
    given [ (1..333).hyper(:32batch).grep: { is-practical($_) } ];

printf "%5s is practical? %s\n", $_, .&is-practical for 666, 6666, 66666, 672, 720;
