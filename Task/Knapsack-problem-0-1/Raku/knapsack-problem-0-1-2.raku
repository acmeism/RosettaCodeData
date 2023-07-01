my $raw = q:to/TABLE/;
    map                      9  150
    compass                 13   35
    water                  153  200
    sandwich                50  160
    glucose                 15   60
    tin                     68   45
    banana                  27   60
    apple                   39   40
    cheese                  23   30
    beer                    52   10
    suntancream             11   70
    camera                  32   30
    T-shirt                 24   15
    trousers                48   10
    umbrella                73   40
    waterproof trousers     42   70
    waterproof overclothes  43   75
    note-case               22   80
    sunglasses               7   20
    towel                   18   12
    socks                    4   50
    book                    30   10
TABLE

my (@name, @weight, @value);

for $raw.lines.sort({-($_ ~~ m/\d+/)}).comb(/\S+[\s\S+]*/) -> $n, $w, $v {
    @name.push:   $n;
    @weight.push: $w;
    @value.push:  $v;
}

my $sum = 400;

my @subset;

sub optimal ($item, $sub-sum) {
    return 0, [] if $item < 0;
    return |@subset[$item][$sub-sum] if @subset[$item][$sub-sum];

    my @next = optimal($item-1, $sub-sum);

    if @weight[$item] > $sub-sum {
        @subset[$item][$sub-sum] = @next
    } else {
        my @skip = optimal($item-1, $sub-sum - @weight[$item]);

        if (@next[0] > @skip[0] + @value[$item] ) {
            @subset[$item][$sub-sum] = @next;
        } else {
            @subset[$item][$sub-sum] = @skip[0] + @value[$item], [|@skip[1], @name[$item]];
        }
    }

    |@subset[$item][$sub-sum]
}

my @solution = optimal(@name.end, $sum);
put "@solution[0]: ", @solution[1].sort.join(', ');
