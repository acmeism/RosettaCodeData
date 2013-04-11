sub swap_rows    ( @M,         $r1, $r2 ) { @M[ $r1, $r2 ] = @M[ $r2, $r1 ] };
sub scale_row    ( @M, $scale, $r       ) { @M[$r]  =              @M[$r]  X* $scale   };
sub shear_row    ( @M, $scale, $r1, $r2 ) { @M[$r1] = @M[$r1] Z+ ( @M[$r2] X* $scale ) };
sub reduce_row   ( @M,         $r,  $c  ) { scale_row( @M, 1/@M[$r][$c], $r ) };
sub clear_column ( @M,         $r,  $c  ) {
    for @M.keys.grep( * != $r ) -> $row_num {
        shear_row( @M, -1*@M[$row_num][$c], $row_num, $r );
    }
}

my @M = (
    [<  1   2   -1    -4 >],
    [<  2   3   -1   -11 >],
    [< -2   0   -3    22 >],
);

my $column_count = +@( @M[0] );

my $current_col = 0;
while all( @M».[$current_col] ) == 0 {
    $current_col++;
    return if $current_col == $column_count; # Matrix was all-zeros.
}

for @M.keys -> $current_row {
    reduce_row(   @M, $current_row, $current_col );
    clear_column( @M, $current_row, $current_col );
    $current_col++;
    return if $current_col == $column_count;
}

say @($_)».fmt(' %4g') for @M;
