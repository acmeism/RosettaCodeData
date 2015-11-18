use Algorithm::Combinatorics "subsets";
my @S = ("a","b","c");
my @PS;
my $iter = subsets(\@S);
while (my $p = $iter->next) {
  push @PS, "[@$p]"
}
say join("  ",@PS);
