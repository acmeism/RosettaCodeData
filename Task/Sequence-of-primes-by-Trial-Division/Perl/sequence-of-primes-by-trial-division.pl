sub isprime {
  my $n = shift;
  return ($n >= 2) if $n < 4;
  return unless $n % 2 && $n % 3;
  my $sqrtn = int(sqrt($n));
  for (my $i = 5; $i <= $sqrtn; $i += 6) {
    return unless $n % $i && $n % ($i+2);
  }
  1;
}

print join(" ", grep { isprime($_) } 0 .. 100 ), "\n";
print join(" ", grep { isprime($_) } 12345678 .. 12345678+100 ), "\n";
