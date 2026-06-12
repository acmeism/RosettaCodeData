my %words = 'unixdict.txt'.IO.slurp.words.map: * => 1;

my (@odds, @evens);

for %words {
    next if .key.chars < 9;
    my $odd  = .key.comb[0,2 … *].join;
    @odds.push(.key => $odd) if %words{$odd} and $odd.chars > 4;
    my $even = .key.comb[1,3 … *].join;
    @evens.push(.key => $even) if %words{$even} and $even.chars > 4;
}

.put for flat 'Odd words > 4:', @odds.sort;

.put for flat "\nEven words > 4:", @evens.sort;
