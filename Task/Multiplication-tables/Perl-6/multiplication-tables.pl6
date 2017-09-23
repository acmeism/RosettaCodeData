my $max = 12;
my $width = chars $max**2;
my $f = "%{$width}s";

say 'x'.fmt($f), '│ ', (1..$max).fmt($f);
say '─' x $width, '┼', '─' x $max*$width + $max;
for 1..$max -> $i {
    say $i.fmt($f), '│ ', (
        for 1..$max -> $j {
            $i <= $j ?? $i*$j !! '';
        }
    ).fmt($f);
}
