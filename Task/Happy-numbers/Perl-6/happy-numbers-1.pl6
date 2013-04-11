sub happy (Int $n is copy --> Bool) {
  my %seen;
  loop {
      $n = [+] $n.comb.map: { $_ ** 2 }
      return True  if $n == 1;
      return False if %seen{$n}++;
  }
}

say join ' ', grep(&happy, 1 .. *)[^8];
