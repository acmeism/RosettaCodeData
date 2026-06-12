use Lingua::EN::Numbers;

for 500
   ,10**8
   ,10**25
   ,10**35
   -> $threshold {
    my $limit = $threshold.base(16);
    my $i  = $limit.index: ['A'..'F'];
    quietly $limit = $limit.substr(0, $i) ~ ('9' x ($limit.chars - $i)) if $i.Str;

    for '  CAN  ', $limit,
        'CAN NOT', $threshold - $limit {
        printf( "Quantity of numbers up to %s that %s be expressed in hexadecimal without using any alphabetics: %*s\n",
         comma($threshold), $^a, comma($threshold).chars, comma($^c) )
    }

    say '';
}
