use v5.16;
say sub {
  my $n = shift;
  $n < 2 ? $n : __SUB__->($n-2) + __SUB__->($n-1)
}->($_) for 0..10
