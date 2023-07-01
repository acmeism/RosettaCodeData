class Wireworld {
    has @.line;
    method height () { @!line.elems }
    has int $.width;

    multi method new(@line) { samewith :@line, :width(max @line».chars) }
    multi method new($str ) { samewith $str.lines }

    method gist { join "\n", @.line }

    method !neighbors($i where ^$.height, $j where ^$.width)
    {
        my @i = grep ^$.height, $i «+« (-1, 0, 1);
        my @j = grep ^$.width,  $j «+« (-1, 0, 1);
        gather for @i X @j -> (\i, \j) {
            next if [ i, j ] ~~ [ $i, $j ];
            take @!line[i].comb[j];
        }
    }
    method succ {
        my @succ;
        for ^$.height X ^$.width -> ($i, $j) {
            @succ[$i] ~=
            do given @!line[$i].comb[$j] {
                when 'H' { 't' }
                when 't' { '.' }
                when '.' {
                    grep('H', self!neighbors($i, $j)) == 1|2 ?? 'H' !! '.'
                }
                default { ' ' }
            }
        }
        return self.new: @succ;
    }
}

my %*SUB-MAIN-OPTS;
%*SUB-MAIN-OPTS<named-anywhere> = True;

multi sub MAIN (
    IO()      $filename,
    Numeric:D :$interval = 1/4,
    Bool      :$stop-on-repeat,
) {
    run-loop :$interval, :$stop-on-repeat, Wireworld.new: $filename.slurp;
}

#| run a built-in example
multi sub MAIN (
    Numeric:D :$interval = 1/4,
    Bool      :$stop-on-repeat,
) {
    run-loop :$interval, :$stop-on-repeat, Wireworld.new: Q:to/END/
    tH.........
    .   .
       ...
    .   .
    Ht.. ......
    END
}

sub run-loop (
    Wireworld:D     $initial,
    Real:D(Numeric) :$interval = 1/4,
    Bool            :$stop-on-repeat
){
    my %seen is SetHash;

    for $initial ...^ * eqv * { # generate a sequence (uses .succ)
        print "\e[2J";
        say '#' x $initial.width;
        .say;
        say '#' x $initial.width;

        if $stop-on-repeat {
            last if %seen{ .gist }++;
        }

        sleep $interval;
    }
}
