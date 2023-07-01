use List::Util qw/sum0 product/;
my @list = (1..9);

say "Sum: ", sum0(@list);    # sum0 returns 0 for an empty list
say "Product: ", product(@list);
