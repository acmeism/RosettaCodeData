sub is_munchausen ( Int $n ) {
    constant @powers = 0, |map { $_ ** $_ }, 1..9;
    $n == @powers[$n.comb].sum;
}
.say if .&is_munchausen for 1..5000;
