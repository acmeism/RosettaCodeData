sub nonsqr { my $n = shift;  $n + int(0.5 + sqrt $n) }

print join(' ', map nonsqr($_), 1..22), "\n";

foreach my $i (1..1_000_000) {
  my $root = sqrt nonsqr($i);
  die "Oops, nonsqr($i) is a square!" if $root == int $root;
}
