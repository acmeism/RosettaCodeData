my $hex = 'FEDCBA987654321';        # largest possible hex number
my $magic-number = [lcm] 1 .. 15;   # find least common multiple
my $div = :16($hex) div $magic-number * $magic-number;

# hunt for target stepping backwards in multiples of the lcm
my $target = ($div, * - $magic-number ... 0).race.first: -> \test {
    my \num= test.base(16);
    (num.contains('0') || num.comb.Bag.values.max > 1) ?? False !! True
};
my $hexnum = $target.base(16);

say "Found $hexnum"; # Found a solution, display it

say ' ' x 12, 'In base 16', ' ' x 36, 'In base 10';
for $hexnum.comb {
    printf "%s / %s = %s  |  %d / %2d = %19d\n",
        $hexnum, $_, ($target / :16($_)).base(16),
        $target, :16($_), $target / :16($_);}
