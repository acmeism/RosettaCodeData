my $p1 = run 'echo', 'Hello, world', :out;
my $p2 = run 'cat', '-n', :in($p1.out), :out;
say $p2.out.slurp-rest;
