constant @triples = (5, *+6 … *).map: -> \n { $_ if .all.is-prime given (n, n+2, n+6) }

my $count = @triples.first: :k, *.[0] >= 5500;

say .fmt('%4d') for @triples.head($count);
