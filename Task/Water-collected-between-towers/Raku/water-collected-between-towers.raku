sub max_l ( @a ) {  [\max] @a }
sub max_r ( @a ) { ([\max] @a.reverse).reverse }

sub water_collected ( @towers ) {
    return 0 if @towers <= 2;

    my @levels = max_l(@towers) »min« max_r(@towers);

    return ( @levels »-« @towers ).grep( * > 0 ).sum;
}

say map &water_collected,
    [ 1, 5,  3, 7, 2 ],
    [ 5, 3,  7, 2, 6, 4, 5, 9, 1, 2 ],
    [ 2, 6,  3, 5, 2, 8, 1, 4, 2, 2, 5, 3, 5, 7, 4, 1 ],
    [ 5, 5,  5, 5 ],
    [ 5, 6,  7, 8 ],
    [ 8, 7,  7, 6 ],
    [ 6, 7, 10, 7, 6 ],
;
