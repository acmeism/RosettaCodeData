sub MAIN (*@files) {
    my %norm;
    do for @files -> $file {
        %norm.push: $file X=> slurp($file).lc.words;
    }
    (my %inv).push: %norm.invert.unique;

    while prompt("Search terms: ").words -> @words {
        for @words -> $word {
            say "$word => {%inv.{$word.lc}//'(not found)'}";
        }
    }
}
