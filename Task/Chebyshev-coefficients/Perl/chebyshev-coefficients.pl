use constant PI => 2 * atan2(1, 0);

sub chebft {
  my($func, $a, $b, $n) = @_;
  my($bma, $bpa) = ( 0.5*($b-$a), 0.5*($b+$a) );

  my @pin = map { ($_ + 0.5) * (PI/$n) } 0..$n-1;
  my @f   = map { $func->( cos($_) * $bma + $bpa ) } @pin;
  my @c   = (0) x $n;
  for my $j (0 .. $n-1) {
      $c[$j] += $f[$_] * cos($j * $pin[$_]) for 0..$n-1;
      $c[$j] *= (2.0/$n);
  }
  @c
}

printf "%+13.7e\n", $_ for chebft(sub{cos($_[0])}, 0, 1, 10);
