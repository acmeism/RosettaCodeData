use ntheory qw/:all/;
my @smith;
forcomposites {
  push @smith, $_  if sumdigits($_) == sumdigits(join("",factor($_)));
} 10000-1;
say scalar(@smith), " Smith numbers below 10000.";
say "@smith";
