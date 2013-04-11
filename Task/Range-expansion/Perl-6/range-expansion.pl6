sub range-expansion (Str $range-description) {
    my $range-pattern = rx/ ( '-'? \d+ ) '-' ( '-'? \d+) /;
    my &expand = -> $term { $term ~~ $range-pattern ?? +$0..+$1 !! $term };
    return $range-description.split(',').map(&expand)
}

say range-expansion('-6,-3--1,3-5,7-11,14,15,17-20').join(', ');
