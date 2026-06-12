use ntheory:from<Perl5> <:all>;

my $start = now;
my $pi = Pi(1e6);
my $took = now - $start;

printf "Pi = %s..%s\n\nPi calculation took %0.3f seconds.\n",
  $pi.Str.substr(0,30), $pi.Str.substr(*-30), $took;
