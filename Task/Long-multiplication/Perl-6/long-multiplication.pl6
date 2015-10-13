sub num_to_groups ( $num ) { $num.flip.comb(/.**1..4/)».flip     };
sub groups_to_num ( @g   ) { [~] flat @g.pop, @g.reverse».fmt('%04d') };

sub long_multiply ( Str $x, Str $y ) {
    my @group_sums;
    for flat num_to_groups($x).pairs X num_to_groups($y).pairs -> $xp, $yp {
        @group_sums[ $xp.key + $yp.key ] += $xp.value * $yp.value;
    }

    for @group_sums.keys -> $k {
        next if @group_sums[$k] < 10000;
        @group_sums[$k+1] += @group_sums[$k].Int div 10000;
        @group_sums[$k] %= 10000;
    }

    return groups_to_num @group_sums;
}

long_multiply( '18446744073709551616', '18446744073709551616' ).say;
