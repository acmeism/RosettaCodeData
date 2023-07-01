use Algorithm::Combinatorics qw/combinations_with_repetition/;
my $iter = combinations_with_repetition([qw/iced jam plain/], 2);
while (my $p = $iter->next) {
  print "@$p\n";
}
# Not an efficient way: generates them all in an array!
my $count =()= combinations_with_repetition([1..10],7);
print "There are $count ways to pick 7 out of 10\n";
