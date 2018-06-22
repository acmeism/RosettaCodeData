use ntheory ":all";

# Count derangements using derangement iterator
sub countderange {
  my($n,$s) = (shift,0);
  forderange { $s++ } $n;
  $s;
}
# Count derangements using inclusion-exclusion
sub subfactorial1 {
  my $n = shift;
  vecsum(map{ vecprod((-1)**($n-$_),binomial($n,$_),factorial($_)) }0..$n);
}
# Count derangements using simple recursion without special functions
sub subfactorial2 {
  my $n = shift;
  use bigint;  no warnings 'recursion';
  ($n < 1)  ?  1  :  $n * subfactorial2($n-1) + (-1)**$n;
}

print "Derangements of 4 items:\n";
forderange { print "@_\n" } 4;
printf "\n%3s %15s %15s\n","N","List count","!N";
printf "%3d %15d %15d %15d\n",$_,countderange($_),subfactorial1($_),subfactorial2($_) for 0..9;
printf "%3d %15s %s\n",$_,"",subfactorial2($_) for 20,200;
