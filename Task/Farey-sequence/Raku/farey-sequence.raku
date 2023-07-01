sub farey ($order) {
    my @l = 0/1, 1/1;
    (2..$order).map: { push @l, |(1..$^d).map: { $_/$d } }
    unique @l
}

say "Farey sequence order ";
.say for (1..11).hyper(:1batch).map: { "$_: ", .&farey.sort.map: *.nude.join('/') };
.say for (100, 200 ... 1000).race(:1batch).map: { "Farey sequence order $_ has " ~ [.&farey].elems ~ ' elements.' }
