sub funkshun ($a, $b?, :$c = 15, :$d, *@e, *%f) {
   say "$a $b $c $d";
   say join ' ', @e;
   say join ' ', keys %f;
}

# this particularly thorny call:

funkshun
    'Alfa', k1 => 'v1', c => 'Charlie', 'Bravo', 'e1',
    d => 'Delta', 'e2', k2 => 'v2';
