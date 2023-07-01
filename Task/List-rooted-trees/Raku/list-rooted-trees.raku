use v6;

multi expand-tree ( Bag $tree ) {
    bag(bag(bag()) (+) $tree) (+)
    [(+)] (
        $tree.keys ==> map {
            $^a.&expand-tree.map: * (+) ( $tree (-) bag($^a) )
        }
    );
}

multi expand-trees ( Bag $trees ) {
    [(+)] $trees.keys.map:  { $_.&expand-tree } ;
}

my $n = 5;
for ( bag(), bag(bag()), *.&expand-trees ... * )[$n] {
    print ++$,".\t";
    .say
};
