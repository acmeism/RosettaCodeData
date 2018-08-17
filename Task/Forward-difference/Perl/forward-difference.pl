sub dif {
  my @s = @_;
  map { $s[$_+1] - $s[$_] } 0 .. $#s-1
}

@a = qw<90 47 58 29 22 32 55 5 55 73>;
while (@a) { printf('%6d', $_) for @a = dif @a; print "\n" }
