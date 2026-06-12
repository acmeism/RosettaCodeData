sub sattolo-cycle (@array) {
    for reverse 1 .. @array.end -> $i {
        my $j = (^$i).pick;
        @array[$j, $i] = @array[$i, $j];
    }
}

my @a = flat 'A' .. 'Z', 'a' .. 'z';

say @a;
sattolo-cycle(@a);
say @a;
