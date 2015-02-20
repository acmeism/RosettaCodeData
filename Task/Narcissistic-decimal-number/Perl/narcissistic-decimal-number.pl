sub is_narcissistic {
  my $n = shift;
  my($k,$sum) = (length($n),0);
  $sum += $_**$k for split(//,$n);
  $n == $sum;
}
my $i = 0;
for (1..25) {
  $i++ while !is_narcissistic($i);
  say $i++;
}
