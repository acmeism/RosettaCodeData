sub base_to {
  my($n,$b) = @_;
  my $s = "";
  while ($n) {
    $s .= ('0'..'9','a'..'z')[$n % $b];
    $n = int($n/$b);
  }
  scalar(reverse($s));
}
sub base_from {
  my($n,$b) = @_;
  my $t = 0;
  for my $c (split(//, lc($n))) {
    $t = $b * $t + index("0123456789abcdefghijklmnopqrstuvwxyz", $c);
  }
  $t;
}
