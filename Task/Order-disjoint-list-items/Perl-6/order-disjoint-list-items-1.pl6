sub order-disjoint-list-items(\M, \N) {
    my \bag = N.BagHash;
    M.map: { bag{$_}-- ?? N.shift !! $_ }
}
