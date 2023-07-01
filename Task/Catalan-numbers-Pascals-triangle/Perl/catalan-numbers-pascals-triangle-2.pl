use ntheory qw/binomial/;
print join(" ", map { binomial( 2*$_, $_) / ($_+1) } 1 .. 1000), "\n";
