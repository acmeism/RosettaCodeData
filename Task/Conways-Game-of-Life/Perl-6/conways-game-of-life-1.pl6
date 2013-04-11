class Grid {
    has Int $.width;
    has Int $.height;
    has @!a;

    multi method new (@a) {
    # Makes a new grid with @!a equal to @a.
        Grid.bless(*,
            width => @a[0].elems, height => @a.elems,
            a => @a)
    }

    multi method new (Str $s) {
    # Interprets the string as a grid.
        Grid.new(map
            { [map { $^c eq '#' ?? True !! False }, split '', $^l] },
            grep /\N/, split "\n", $s)
    }

    method clone { Grid.new(map { [$^x.clone] }, @!a) }

    method Str {
        [~] map
            { [~] map({ $^c ?? '#' !! '.' }, |$^row), "\n" },
            @!a
    }

    method alive (Int $row, Int $col --> Bool) {
        0 <= $row < $.height and 0 <= $col < $.width
            and @!a[$row][$col];
    }

    method nextgen {
        my $prev = self.clone;
        for ^$.height -> $row {
            for ^$.width -> $col {
                my $v = [+]
                    map({ $prev.alive($^r, $^c) },
                        ($col - 1, $col, $col + 1 X
                         $row - 1, $row, $row + 1)),
                    -$prev.alive($row, $col);
                @!a[$row][$col] =
                    $prev.alive($row, $col) && $v == 2 || $v == 3;
            }
        }
    }
}
