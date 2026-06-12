my @n-n1-triangular = map { $_, $_ + 1, $_ + ($_ + 1) }, ^Inf;

my @wanted = @n-n1-triangular.grep: *.[2].is-prime;

printf "%2d + %2d = %2d\n", |.list for @wanted.head(20);
