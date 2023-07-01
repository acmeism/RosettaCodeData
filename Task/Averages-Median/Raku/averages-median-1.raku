sub median {
  my @a = sort @_;
  return (@a[(*-1) div 2] + @a[* div 2]) / 2;
}
