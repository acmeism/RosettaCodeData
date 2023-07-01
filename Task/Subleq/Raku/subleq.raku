my @hello-world =
|<15 17 -1 17 -1 -1 16 1 -1 16 3 -1 15 15 0 0 -1>,
|"Hello, world!\n\0".comb.map(*.ord);

sub run-subleq(@memory) {
  my $ip = 0;
  while $ip >= 0 && $ip < @memory {
    my ($a, $b, $c) = @memory[$ip..*];
    $ip += 3;
    if $a < 0 {
      @memory[$b] = getc.ord;
    } elsif $b < 0 {
      print @memory[$a].chr;
    } else {
      if (@memory[$b] -= @memory[$a]) <= 0 {
        $ip = $c;
      }
    }
  }
}

run-subleq @hello-world;
