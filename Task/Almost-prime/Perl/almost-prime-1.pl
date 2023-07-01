use ntheory qw/factor/;
sub almost {
  my($k,$n) = @_;
  my $i = 1;
  map { $i++ while scalar factor($i) != $k; $i++ } 1..$n;
}
say "$_ : ", join(" ", almost($_,10)) for 1..5;
