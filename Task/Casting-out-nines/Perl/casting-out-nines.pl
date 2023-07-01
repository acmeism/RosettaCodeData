sub co9 {  # Follows the simple procedure asked for in Part 1
  my $n = shift;
  return $n if $n < 10;
  my $sum = 0; $sum += $_ for split(//,$n);
  co9($sum);
}

sub showadd {
  my($n,$m) = @_;
  print "( $n [",co9($n),"] + $m [",co9($m),"] ) [",co9(co9($n)+co9($m)),"]",
        "   =   ", $n+$m," [",co9($n+$m),"]\n";
}

sub co9filter {
  my $base = shift;
  die unless $base >= 2;
  my($beg, $end, $basem1) = (1, $base*$base-1, $base-1);
  my @list = grep { $_ % $basem1 == $_*$_ % $basem1 } $beg .. $end;
  ($end, scalar(@list), @list);
}

print "Part 1: Create a simple filter and demonstrate using simple example.\n";
showadd(6395, 1259);

print "\nPart 2: Use this to filter a range with co9(k) == co9(k^2).\n";
print join(" ", grep { co9($_) == co9($_*$_) } 1..99), "\n";

print "\nPart 3: Use efficient method on range.\n";
for my $base (10, 17) {
  my($N, $n, @l) = co9filter($base);
  printf "[@l]\nIn base %d, trying %d numbers instead of %d saves %.4f%%\n\n",
         $base, $n, $N, 100-($n/$N)*100;
}
