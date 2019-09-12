my $raw = qq:to/TABLE/;
map             9       150     1
compass         13      35      1
water           153     200     2
sandwich        50      60      2
glucose         15      60      2
tin             68      45      3
banana          27      60      3
apple           39      40      3
cheese          23      30      1
beer            52      10      1
suntancream     11      70      1
camera          32      30      1
T-shirt         24      15      2
trousers        48      10      2
umbrella        73      40      1
w_trousers      42      70      1
w_overcoat      43      75      1
note-case       22      80      1
sunglasses       7      20      1
towel           18      12      2
socks            4      50      1
book            30      10      2
TABLE

my @items;
for split(["\n", /\s+/], $raw, :skip-empty) -> $n,$w,$v,$q {
    @items.push: %{ name => $n, weight => $w, value => $v, quant => $q}
}

my $max_weight = 400;

sub pick ($weight, $pos) {
    state %cache;
    return 0, 0 if $pos < 0 or $weight <= 0;

    my $key = $weight ~ $pos;
    %cache{$key} or do {
        my %item = @items[$pos];
        my ($bv, $bi, $bw, @bp) = (0, 0, 0);

        for 0 .. %item{'quant'} -> $i {
            last if $i * %item{'weight'} > $weight;
            my ($v, $w, @p) = pick($weight - $i * %item{'weight'}, $pos - 1);
            next if ($v += $i * %item{'value'}) <= $bv;

            ($bv, $bi, $bw, @bp) = ($v, $i, $w, |@p);
        }
        %cache{$key} = $bv, $bw + $bi * %item{'weight'}, |@bp, $bi;
    }
}

my ($v, $w, @p) = pick($max_weight, @items.end);
{ say "{@p[$_]} of @items[$_]{'name'}" if @p[$_] } for 0 .. @p.end;
say "Value: $v Weight: $w";
