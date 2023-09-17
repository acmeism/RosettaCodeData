my @abc = 'a'..'z';
my $abc = [@abc».uc, @abc];
put .trans: $abc => $abc».rotate(13) for lines
