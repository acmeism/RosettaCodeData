my $threshold = 10000;

my @twins = unique flat (3..$threshold).grep(&is-prime).map: { $_, $_+2 if ($_+2).is-prime };
my @sums;

map {++@sums[$_]}, (@twins X+ @twins);
display 'Non twin prime sums:', @sums;

map {++@sums[$_]}, flat 2, (1 X+ @twins);
display "\nNon twin prime sums (including 1):", @sums;

sub display ($msg, @p) {
    put "$msg\n" ~ @p[^$threshold].kv.map(-> $k, $v { $k if ($k %% 2) && !$v })\
    .skip(1).batch(10)».fmt("%4d").join: "\n"
}
