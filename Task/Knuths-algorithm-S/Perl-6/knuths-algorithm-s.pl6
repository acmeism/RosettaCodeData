sub s_of_n_creator($n) {
    my @sample;
    my $i = 0;
    -> $item {
        if ++$i <= $n {
            push @sample, $item;
        }
        elsif $i.rand < $n {
            @sample[$n.rand] = $item;
        }
        @sample;
    }
}

my @items = 0..9;
my @bin;

for ^100000 {
    my &s_of_n = s_of_n_creator(3);
    my @sample;
    for @items -> $item {
        @sample = s_of_n($item);
    }
    for @sample -> $s {
        @bin[$s]++;
    }
}
say @bin;
