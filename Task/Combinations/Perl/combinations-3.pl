use Algorithm::Combinatorics qw/combinations/;
my $iter = combinations([0..4],3);
while (my $c = $iter->next) {
  print "@$c\n";
}
