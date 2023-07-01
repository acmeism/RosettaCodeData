sub isKap {
  my $k = shift;
  return if $k*($k-1) % 9;  # Fast return "casting out nines"
  my($k2, $p) = ($k*$k, 10);
  do {
    my $i = int($k2/$p);
    my $j = $k2 % $p;
    return 1 if $j && $i+$j == $k;
    $p *= 10;
  } while $p <= $k2;
  0;
}

print "[", join(" ", grep { isKap($_) } 1..9999), "]\n\n";
my @kaprekar;
isKap($_) && push @kaprekar,$_ for 1..1_000_000;
print "Kaprekar Numbers below 1000000: ", scalar(@kaprekar), "\n";
