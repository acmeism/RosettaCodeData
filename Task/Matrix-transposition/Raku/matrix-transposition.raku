# Transposition can be done with the reduced zip meta-operator
# on list-of-lists data structures

say [Z] (<A B C D>, <E F G H>, <I J K L>);

# For native shaped arrays, a more traditional procedure of copying item-by-item
# Here the resulting matrix is also a native shaped array

my @a[3;4] =
  [
    [<A B C D>],
    [<E F G H>],
    [<I J K L>],
  ];

(my $n, my $m) = @a.shape;
my @b[$m;$n];
for ^$m X ^$n -> (\i, \j) {
   @b[i;j] = @a[j;i];
}

say @b;
