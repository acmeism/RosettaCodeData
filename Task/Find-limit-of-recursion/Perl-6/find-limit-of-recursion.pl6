my $x = 0;
recurse;

sub recurse () {
   ++$x;
   say $x if $x %% 1_000_000;
   recurse;
}
