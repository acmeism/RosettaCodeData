sub huffman (%frequencies) {
    my @queue = %frequencies.map({ [.value, .key] }).sort;
    while @queue > 1 {
        given @queue.splice(0, 2) -> ([$freq1, $node1], [$freq2, $node2]) {
            @queue = (|@queue, [$freq1 + $freq2, [$node1, $node2]]).sort;
        }
    }
    hash gather walk @queue[0][1], '';
}

multi walk ($node,            $prefix) { take $node => $prefix; }
multi walk ([$node1, $node2], $prefix) { walk $node1, $prefix ~ '0';
                                         walk $node2, $prefix ~ '1'; }
