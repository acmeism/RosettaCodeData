sub from-base(Str $str, Int $base) {
    +":$base\<$str>";
}

sub to-base(Real $num, Int $base) {
    $num.base($base);
}
