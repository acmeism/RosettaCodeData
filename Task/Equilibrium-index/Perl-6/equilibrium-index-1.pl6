sub equilibrium_index(@list) {
    my ($left,$right) = 0, [+] @list;

    gather for @list.kv -> $i, $x {
        $right -= $x;
        take $i if $left == $right;
        $left += $x;
    }
}

my @list = -7, 1, 5, 2, -4, 3, 0;
.say for equilibrium_index(@list);
