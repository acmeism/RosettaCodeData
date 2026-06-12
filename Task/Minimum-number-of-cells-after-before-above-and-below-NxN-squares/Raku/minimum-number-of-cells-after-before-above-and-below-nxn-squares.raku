sub distance-to-edge (\N) {
   my $c = ceiling N / 2;
   my $f = floor   N / 2;
   my @ul = ^$c .map: -> $x { [ ^$c .map: { min($x, $_) } ] }
   @ul[$_].append: reverse @ul[$_; ^$f] for ^$c;
   @ul.push: [ reverse @ul[$_] ] for reverse ^$f;
   @ul
}

for 0, 1, 2, 6, 9, 23 {
    my @dte = .&distance-to-edge;
    my $max = chars max flat @dte».Slip;

    say "\n$_ x $_ distance to nearest edge:";
    .fmt("%{$max}d").say for @dte;
}
