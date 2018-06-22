sub spiral_matrix ( $n ) {
    my @sm;
    my $len = $n;
    my $pos = 0;

    for ^($n/2).ceiling -> $i {
        my $j = $i +  1;
        my $e = $n - $j;

        @sm[$i     ][$i + $_] = $pos++ for         ^(  $len); # Top
        @sm[$j + $_][$e     ] = $pos++ for         ^(--$len); # Right
        @sm[$e     ][$i + $_] = $pos++ for reverse ^(  $len); # Bottom
        @sm[$j + $_][$i     ] = $pos++ for reverse ^(--$len); # Left
    }

    return @sm;
}

say .fmt('%3d') for spiral_matrix(5);
