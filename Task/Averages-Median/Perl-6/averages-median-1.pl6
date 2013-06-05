sub median {
  my @a = sort @_;
  return (@a[@a.end / 2] + @a[@a / 2]) / 2;
}
