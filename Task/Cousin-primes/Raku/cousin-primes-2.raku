constant @cousins = (3, 7, *+6 … *).map: -> \n { (n, n+4) if (n & n+4).is-prime };

my $count = @cousins.first: :k, *.[0] > 1000;

.say for @cousins.head($count).batch(9);
