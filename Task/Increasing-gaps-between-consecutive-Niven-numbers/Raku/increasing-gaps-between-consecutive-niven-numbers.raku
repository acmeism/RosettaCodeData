use Lingua::EN::Numbers;

unit sub MAIN (Int $threshold = 10000000);

my int $index = 0;
my int $last  = 0;
my int $gap   = 0;

say 'Gap    Index of gap  Starting Niven';

for 1..* -> \count {
    next unless count %% sum count.comb;
    if (my \diff = count - $last) > $gap {
        $gap = diff;
        printf "%3d %15s %15s\n", $gap, comma($index || 1), comma($last || 1);
    }
    ++$index;
    $last = count;
    last if $index >= $threshold;
}
