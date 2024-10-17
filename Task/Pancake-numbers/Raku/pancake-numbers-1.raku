# Updated: 20240901 Raku programming solution

sub pancake(Int $n) {
   loop ( my ($gap, $pg, $sum_gaps, $adj) = <2 1 2 -1> ; ; $sum_gaps += $gap ) {
      $sum_gaps < $n ?? ( $adj += 1 ) !! return $n + $adj;
      ($pg, $gap) = ($gap, $gap + $pg)
   }
}

for (1..20).rotor(5) { @_».&{printf "p(%2d) = %2d   ",$_,pancake $_} and say() }
