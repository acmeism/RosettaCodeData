# Deconvolution of N dimensional matricies.
sub deconv_ND ( @g, @f ) {
    my @gsize = size_of @g;
    my @fsize = size_of @f;
    my @hsize = @gsize >>-<< @fsize >>+>> 1;

    my @toSolve = loopcoords(@gsize).map:
      { [row(@g, @f, @gsize, $^coords, @fsize, @hsize)] };

    my @solved = rref( @toSolve );

    # Uncomment if you want to see the rref system of equations.
    # pretty_print( @solved );

    my @h;
    my $index = 0;
    insert(@h, $_, @solved[$index++][*-1]) for loopcoords(@hsize);
    return @h;

    # Inserts a value in the correct spot in an N dimensional array.
    sub insert ( $array is rw, @coords is copy, $value ) {
        my $level = @coords.shift;
        if +@coords {
             insert( $array[$level], @coords, $value );
        } else {
             $array[$level] = $value;
        }
    }
}

# Returns a list containing the number of elements in
# each level of an N dimensional array.
sub size_of ( $m is copy ) {
    my @size;
    while $m ~~ Array { @size.push(+$m); $m = $m[0]; }
    return @size;
}

# Construct a row (equation) for each value in @g to be sent
# to the simultaneous equation solver.
# @Xsize   = Dimensions of @X, # of elems per level.
# @Xcoords = Path to each element of @X given as a series of indicies.
sub row ( @g, @f, @gsize, @gcoords, @fsize, $hsize ) {
    my @row;
    for loopcoords( $hsize ) -> @hcoords {
        my @fcoords;
        for ^@hcoords -> $index {
            my $window = @gcoords[$index] - @hcoords[$index];
            @fcoords.push($window) and next if 0 <= $window < @fsize[$index];
            last;
        }
        @row.push( +@fcoords == +@hcoords ?? fetch( @f, |@fcoords ) !! 0 );
    }
    @row.push( fetch( @g, |@gcoords ) );
    return @row;

    # Returns the value found in @array with the
    # coordinates given in the list of @indicies.
    sub fetch (@array, *@indicies) {
        my $index = @indicies.shift;
        return @array[*-1] ~~ Array
          ?? fetch( @array[$index], @indicies )
          !! @array[$index];
    }
}

# Constructs an array of arrays of coordinates to each
# element in an N dimensional array.
sub loopcoords ( @hsize ) {
    my @hcoords;
    for ^([*] @hsize) -> $index {
	my @coords;
	my $j = $index;
	for @hsize -> $dim {
	    @coords.push( $j % $dim );
	    $j div= $dim;
	}
	@hcoords.push( [@coords] );
    }
    return @hcoords;
}

# Reduced Row Echelon Form simultaneous equation solver.
# Can handle over-specified systems of equations.
# (n unknowns in n + m equations)
sub rref ($m is rw) {
    return unless $m;
    my ($lead, $rows, $cols) = 0, +$m, +$m[0];

    # Trim off over specified rows if they exist.
    # Not strictly necessary, but can save a lot of
    # redundant calculations.
    if $rows >= $cols {
        $m = trim_system($m);
        $rows = +$m;
    }

    for ^$rows -> $r {
        $lead < $cols or return $m;
        my $i = $r;
        until $m[$i][$lead] {
            ++$i == $rows or next;
            $i = $r;
            ++$lead == $cols and return $m;
        }
        $m[$i, $r] = $m[$r, $i] if $r != $i;
        my $lv = $m[$r][$lead];
        $m[$r] >>/=>> $lv;
        for ^$rows -> $n {
            next if $n == $r;
            $m[$n] >>-=>> $m[$r] >>*>> $m[$n][$lead];
        }
        ++$lead;
    }
    return $m;

    # Reduce a system of equations to n equations with n unknowns.
    # Looks for an equation with a true value for each position.
    # If it can't find one, assumes that it has already taken one
    # and pushes in the first equation it sees. This assumtion
    # will alway be successful except in some cases where an
    # under-specified system has been supplied, in which case,
    # it would not have been able to reduce the system anyway.
    sub trim_system ($m is rw) {
        my ($vars, @t) = +$m[0]-1, ();
        for ^$vars -> $lead {
            for ^$m -> $row {
                @t.push( $m.splice( $row, 1 ) ) and last if $m[$row][$lead];
            }
        }
        while (+@t < $vars) and +$m { @t.push( $m.splice( 0, 1 ) ) };
        return @t;
    }
}
