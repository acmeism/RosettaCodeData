sub new_level ( @stack --> Nil ) {
    my $e = [];
    push @stack.tail, $e;
    push @stack,      $e;
}
sub to_tree_iterative ( @xs --> List ) {
    my $nested = [];
    my @stack  = $nested;

    for @xs -> Int $x {
        new_level(@stack) while $x > @stack;
        pop       @stack  while $x < @stack;
        push @stack.tail, $x;
    }

    return $nested;
}
my @tests = (), (1, 2, 4), (3, 1, 3, 1), (1, 2, 3, 1), (3, 2, 1, 3), (3, 3, 3, 1, 1, 3, 3, 3);
say .Str.fmt( '%15s => ' ), .&to_tree_iterative for @tests;
