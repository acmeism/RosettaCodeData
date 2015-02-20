constant @bars = '▁' ... '█';
while prompt 'Numbers separated by anything: ' -> $_ {
    my @numbers = map +*, .comb(/ '-'? \d+ ['.' \d+]? /);
    my ($mn,$mx) = @numbers.minmax.bounds;
    say "min: $mn.fmt('%5f'); max: $mx.fmt('%5f')";
    my $div = ($mx - $mn) / (@bars - 1);
    say @bars[ (@numbers X- $mn) X/ $div ].join;
}
