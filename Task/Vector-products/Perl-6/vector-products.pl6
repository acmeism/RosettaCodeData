sub infix:<⋅> { [+] @^a »*« @^b }

sub infix:<⨯>([$a1, $a2, $a3], [$b1, $b2, $b3]) {
    [ $a2*$b3 - $a3*$b2,
      $a3*$b1 - $a1*$b3,
      $a1*$b2 - $a2*$b1 ];
}

sub scalar-triple-product { @^a ⋅ (@^b ⨯ @^c) }
sub vector-triple-product { @^a ⨯ (@^b ⨯ @^c) }

my @a = <3 4 5>;
my @b = <4 3 5>;
my @c = <-5 -12 -13>;

say (:@a, :@b, :@c).perl;
say "a ⋅ b = { @a ⋅ @b }";
say "a ⨯ b = <{ @a ⨯ @b }>";
say "a ⋅ (b ⨯ c) = { scalar-triple-product(@a, @b, @c) }";
say "a ⨯ (b ⨯ c) = <{ vector-triple-product(@a, @b, @c) }>";
