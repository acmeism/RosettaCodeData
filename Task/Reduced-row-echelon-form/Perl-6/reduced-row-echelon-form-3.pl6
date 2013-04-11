class Matrix is Array {
    method unscale_row ( @M: $scale, $row ) {
        @M[$row] = @M[$row] X/ $scale;
    }
    method unshear_row ( @M: $scale, $r1, $r2 ) {
        @M[$r1] = @M[$r1] Z- ( @M[$r2] X* $scale );
    }
    method reduce_row ( @M: $row, $col ) {
        @M.unscale_row( @M[$row][$col], $row );
    }
    method clear_column ( @M: $row, $col ) {
        for @M.keys.grep( * != $row ) -> $scanning_row {
            @M.unshear_row( @M[$scanning_row][$col], $scanning_row, $row );
        }
    }
    method reduced_row_echelon_form ( @M: ) {
        my $column_count = +@( @M[0] );

        my $current_col = 0;
        # Skip past all-zero columns.
        while all( @M».[$current_col] ) == 0 {
            $current_col++;
            return if $current_col == $column_count; # Matrix was all-zeros.
        }

        for @M.keys -> $current_row {
            @M.reduce_row(   $current_row, $current_col );
            @M.clear_column( $current_row, $current_col );
            $current_col++;
            return if $current_col == $column_count;
        }
    }
}

my $M = Matrix.new.push(
    [<  1   2   -1    -4 >],
    [<  2   3   -1   -11 >],
    [< -2   0   -3    22 >],
);

$M.reduced_row_echelon_form;

say @($_)».fmt(' %4g') for @($M);
