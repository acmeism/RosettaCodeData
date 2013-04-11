constant @coeff = [[+1, -2, +2], [+2, -1, +2], [+2, -2, +3]],
                  [[+1, +2, +2], [+2, +1, +2], [+2, +2, +3]],
                  [[-1, +2, +2], [-2, +1, +2], [-2, +2, +3]];

sub triples($limit) {

    sub oyako(@trippy) {
        my $perim = [+] @trippy;
        return if $perim > $limit;
        take (1 + ($limit div $perim)i);
        for @coeff -> @nine {
            oyako (map -> @three { [+] @three »*« @trippy }, @nine);
        }
        return;
    }

    my $complex = 0i + [+] gather oyako([3,4,5]);
    "$limit => ({$complex.re, $complex.im})";
}

for 10,100,1000 ... * -> $limit {
    say triples $limit;
}
