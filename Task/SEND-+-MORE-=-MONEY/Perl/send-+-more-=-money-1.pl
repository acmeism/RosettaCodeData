use v5.36;
use enum <D E M N O R S Y>;
use Algorithm::Combinatorics <combinations permutations>;

sub solve {
  for my $p (map { permutations $_ } combinations [0..9], 8) {
    return $p if @$p[M] > 0 and join('',@$p[S,E,N,D])+join('',@$p[M,O,R,E]) == join('',@$p[M,O,N,E,Y]);
  }
}

printf "SEND + MORE == MONEY\n%d + %d == %d", join('',@$_[S,E,N,D]), join('',@$_[M,O,R,E]), join('',@$_[M,O,N,E,Y]) for solve();
