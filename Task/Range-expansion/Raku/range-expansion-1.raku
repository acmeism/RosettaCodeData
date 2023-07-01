sub range-expand (Str $range-description) {
    my token number { '-'? \d+ }
    my token range  { (<&number>) '-' (<&number>) }

    $range-description
        .split(',')
        .map({ .match(&range) ?? $0..$1 !! +$_ })
        .flat
}

say range-expand('-6,-3--1,3-5,7-11,14,15,17-20').join(', ');
