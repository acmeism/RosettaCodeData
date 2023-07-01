(my $f = "%{$_}s" given my $width = ($_**2).chars ) given my $max = 12;

say '×'.fmt($f)  ~ ' ┃ ' ~ (1..$max).fmt($f);
say '━' x $width ~ '━╋'  ~ '━' x $max × (1+$width);

for 1..$max -> $i {
    say $i.fmt($f) ~ ' ┃ ' ~ ( $i ≤ $_ ?? $i×$_ !! '' for 1..$max ).fmt($f);
}
