my %anagram = slurp('dict.ie').words.map({[.comb]}).classify({ .sort.join });

for %anagram.values.sort({ -@($_[0]) }) -> @aset {
    for     0   ..^ @aset.end -> $i {
        for $i ^..  @aset.end -> $j {
            if none(  @aset[$i].list Zeq @aset[$j].list ) {
                say "{@aset[$i].join}   {@aset[$j].join}";
                exit;
            }
        }
    }
}
