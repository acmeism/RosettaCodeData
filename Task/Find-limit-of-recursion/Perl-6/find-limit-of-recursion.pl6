my $x = 0;
recurse;

sub recurse () {
   say ++$x;
   recurse;
}
