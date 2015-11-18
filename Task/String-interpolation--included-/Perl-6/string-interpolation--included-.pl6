my $extra = "little";
say "Mary had a $extra lamb";           # variable interpolation
say "Mary had a { $extra } lamb";       # expression interpolation
printf "Mary had a %s lamb.\n", $extra; # standard printf
say $extra.fmt("Mary had a %s lamb");   # inside-out printf
my @lambs = <Jimmy Bobby Tommy>;
say Q :array { $$$ The lambs are called @lambs[]\\\.} # only @-sigiled containers are interpolated
