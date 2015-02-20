sub cast-out(\BASE = 10, \MIN = 1, \MAX = BASE**2 - 1) {
  my \B9 = BASE - 1;
  my @ran = ($_ if $_ % B9 == $_**2 % B9 for ^B9);
  my $x = MIN div B9;
  gather loop {
    for @ran -> \n {
      my \k = B9 * $x + n;
      take k if k >= MIN;
    }
    $x++;
  } ...^ * > MAX;
}

say cast-out;
say cast-out 16;
say cast-out 17;
