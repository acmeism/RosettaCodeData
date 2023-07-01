sub eq_index ( *@list ) {
    my $sum = 0;

    my %h = @list.keys.classify: {
        $sum += @list[$_];
        $sum * 2 - @list[$_];
    };

    return %h{$sum} // [];
}

say eq_index < -7  1  5  2 -4  3  0 >; # 3 6
say eq_index <  2  4  6             >; # (no eq point)
say eq_index <  2  9  2             >; # 1
say eq_index <  1 -1  1 -1  1 -1  1 >; # 0 1 2 3 4 5 6
