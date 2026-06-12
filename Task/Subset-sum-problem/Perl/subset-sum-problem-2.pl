use List::Util qw/sum/;
use Algorithm::Combinatorics qw/combinations/;
foreach my $n (1 .. @names) {
  my $iter = combinations([0..$#weights], $n);
  while (my $c = $iter->next) {
    next if sum(@weights[@$c]);
    print "Length $n: @names[@$c]\n";
    last;
  }
}
