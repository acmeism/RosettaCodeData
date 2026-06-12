use Algorithm::Combinatorics qw/tuples_with_repetition/;
my $iter = tuples_with_repetition([qw/A C K R/], 5);
my $tries = 0;
while (my $p = $iter->next) {
  $tries++;
  die "Found the combination after $tries tries!\n" if join("",@$p) eq "CRACK";
}
