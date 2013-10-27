sub fringe ($tree) {
    multi sub fringey (Pair $node) { fringey $_ for $node.kv; }
    multi sub fringey ( Any $leaf) { take $leaf; }

    gather fringey $tree;
}

sub samefringe ($a, $b) { fringe($a) eqv fringe($b) }
