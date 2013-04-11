sub fringe ($tree) {
    multi sub fringey (Pair $node) { fringey $_ for $node.kv; }
    multi sub fringey ( Any $leaf) { take $leaf; }

    (gather fringey $tree), Cool;
}

sub samefringe ($a, $b) { all fringe($a) Z=== fringe($b) }
