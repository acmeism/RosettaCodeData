constant @bars = '▁' ... '█';
while prompt 'Numbers separated by anything: ' -> $_ {
    my @numbers = map +*, .comb(/ '-'? [[\d+ ['.' \d*]?] | ['.' \d+]] /);
    my ($mn,$mx) = @numbers.minmax.bounds;
    say "min: $mn.fmt('%5f'); max: $mx.fmt('%5f')";
    say @bars[ @numbers.map: { @bars * ($_ - $mn) / ($mx - $mn) min @bars - 1 } ].join;
}
