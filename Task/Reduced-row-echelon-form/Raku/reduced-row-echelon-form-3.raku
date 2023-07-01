class Matrix is Array {
    method  unscale-row ( @M: \scale, \row       ) { @M[row] =            @M[row] »/» scale }
    method  unshear-row ( @M: \scale, \r1,  \r2  ) { @M[r1]  = @M[r1] »-» @M[r2]  »×» scale }
    method   reduce-row ( @M:         \row, \col ) { @M.unscale-row( @M[row;col], row ) }
    method clear-column ( @M:         \row, \col ) { @M.unshear-row( @M[$_;col], $_, row ) for @M.keys.grep: * != row }

    method reduced-row-echelon-form ( @M: ) {
        my $column-count =  @M[0];
        my $col = 0;
        for @M.keys -> $row {
            @M.reduce-row(   $row, $col );
            @M.clear-column( $row, $col );
            return if ++$col == $column-count;
        }
    }
}

my $M = Matrix.new(
    [<  1   2   -1    -4 >],
    [<  2   3   -1   -11 >],
    [< -2   0   -3    22 >],
);

$M.reduced-row-echelon-form;
say @$_».fmt(' %4g') for @$M;
