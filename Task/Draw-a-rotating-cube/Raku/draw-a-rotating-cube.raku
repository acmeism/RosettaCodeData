use Terminal::Caca;
given my $canvas = Terminal::Caca.new {
    .title('Rosetta Code - Rotating cube - Press any key to exit');

    sub scale-and-translate($x, $y, $z) {
        $x * 5 / ( 5 + $z ) * 15 + 40,
        $y * 5 / ( 5 + $z ) *  7 + 15,
        $z;
    }

    sub rotate3d-x( $x, $y, $z, $angle ) {
        my ($cosθ, $sinθ) = cis( $angle * π / 180.0 ).reals;
        $x,
        $y * $cosθ - $z * $sinθ,
        $y * $sinθ + $z * $cosθ;
    }

    sub rotate3d-y( $x, $y, $z, $angle ) {
        my ($cosθ, $sinθ) = cis( $angle * π / 180.0 ).reals;
        $x * $cosθ - $z * $sinθ,
        $y,
        $x * $sinθ + $z * $cosθ;
    }

    sub rotate3d-z( $x, $y, $z, $angle ) {
        my ($cosθ, $sinθ) = cis( $angle * π / 180.0 ).reals;
        $x * $cosθ - $y * $sinθ,
        $x * $cosθ + $y * $sinθ,
        $z;
    }

    # Unit cube from polygon mesh, aligned to axes
    my @mesh =
      [ [1, 1, -1], [-1, -1, -1], [-1,  1, -1] ], # far face
      [ [1, 1, -1], [-1, -1, -1], [ 1, -1, -1] ],
      [ [1, 1,  1], [-1, -1,  1], [-1,  1,  1] ], # near face
      [ [1, 1,  1], [-1, -1,  1], [ 1, -1,  1] ];
      @mesh.push: [$_».rotate( 1)».Array] for @mesh[^4]; # positive and
      @mesh.push: [$_».rotate(-1)».Array] for @mesh[^4]; # negative rotations

    # Rotate to correct orientation for task
    for ^@mesh X ^@mesh[0] -> ($i, $j) {
        @(@mesh[$i;$j]) = rotate3d-x |@mesh[$i;$j], 45;
        @(@mesh[$i;$j]) = rotate3d-z |@mesh[$i;$j], 40;
    }

    my @colors = red, blue, green, cyan, magenta, yellow;

    loop {
        for ^359 -> $angle {
            .color( white, white );
            .clear;

            # Flatten 3D into 2D and rotate for all faces
            my @faces-z;
            my $c-index = 0;
            for @mesh -> @triangle {
                my @points;
                my $sum-z = 0;
                for @triangle -> @node {
                    my ($px, $py, $z) = scale-and-translate |rotate3d-y |@node, $angle;
                    @points.append: $px.Int, $py.Int;
                    $sum-z += $z;
                }

                @faces-z.push: %(
                    color  => @colors[$c-index++ div 2],
                    points => @points,
                    avg-z  => $sum-z / +@points;
                );
            }

            # Draw all faces
            # Sort by z to draw farthest first
            for @faces-z.sort( -*.<avg-z> ) -> %face {
                # Draw filled triangle
                .color( %face<color>, %face<color> );
                .fill-triangle( |%face<points> );
                # And frame
                .color( black, black );
                .thin-triangle( |%face<points> );
            }

            .refresh;
            exit if .wait-for-event(key-press);
        }
    }

    # Cleanup on scope exit
    LEAVE {
        .cleanup;
    }
}
