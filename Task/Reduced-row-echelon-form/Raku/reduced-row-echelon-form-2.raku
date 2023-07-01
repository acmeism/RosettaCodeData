sub    scale-row ( @M, \scale, \r       ) { @M[r]  =              @M[r]  »×» scale   }
sub    shear-row ( @M, \scale, \r1, \r2 ) { @M[r1] = @M[r1] »+» ( @M[r2] »×» scale ) }
sub   reduce-row ( @M,         \r,  \c  ) { scale-row @M, 1/@M[r;c], r }
sub clear-column ( @M,         \r,  \c  ) { shear-row @M, -@M[$_;c], $_, r for @M.keys.grep: * != r }

my @M = (
    [<  1   2   -1    -4 >],
    [<  2   3   -1   -11 >],
    [< -2   0   -3    22 >],
);

my $column-count = @M[0];
my $col = 0;
for @M.keys -> $row {
      reduce-row( @M, $row, $col );
    clear-column( @M, $row, $col );
    last if ++$col == $column-count;
}

say @$_».fmt(' %4g') for @M;
