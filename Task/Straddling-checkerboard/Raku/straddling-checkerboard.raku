class Straddling_Checkerboard {
    has @!flat_board; # 10x3 stored as 30x1
    has $!plain2code; # full translation table, invertable
    has @!table;      # Printable layout, like Wikipedia entry

    my $numeric_escape = '/';
    my $exclude = /<-[A..Z0..9.]>/; # Omit the escape character

    method display_table { gather { take ~ .list for @!table } };

    method decode ( Str $s --> Str ) {
        $s.trans($!plain2code.antipairs);
    }

    method encode ( Str $s, :$collapse? --> Str ) {
        my $replace = $collapse ?? '' !! '.';
        $s.uc.subst( $exclude, $replace, :g ).trans($!plain2code);
    }

    submethod BUILD ( :$alphabet, :$u where 0..9, :$v where 0..9 ) {
        die if $u == $v;
        die if $alphabet.comb.sort.join ne [~] flat './', 'A'..'Z';

        @!flat_board = $alphabet.uc.comb;
        @!flat_board.splice( $u min $v, 0, Any );
        @!flat_board.splice( $u max $v, 0, Any );

        @!table = [ ' ',|            [ 0 ..  9]                              ],
                  [ ' ',|@!flat_board[ 0 ..  9].map: {.defined ?? $_ !! ' '} ],
                  [ $u, |@!flat_board[10 .. 19]                              ],
                  [ $v, |@!flat_board[20 .. 29]                              ];

        my @order = 0..9; # This may be passed as a param in the future

        my @nums = flat @order,
                   @order.map({ +"$u$_" }),
                   @order.map({ +"$v$_" });

        my %c2p = @nums Z=> @!flat_board;
        %c2p{$_}:delete if %c2p{$_} eqv Any for keys %c2p;
        my %p2c = %c2p.invert;
        %p2c{$_} = %p2c{$numeric_escape} ~ $_ for 0..9;
        $!plain2code = [%p2c.keys] => [%p2c.values];
    }
}

sub MAIN ( :$u = 3, :$v = 7, :$alphabet = 'HOLMESRTABCDFGIJKNPQUVWXYZ./' ) {
    my Straddling_Checkerboard $sc .= new: :$u, :$v, :$alphabet;
    $sc.display_table;

    for 0..1 -> $collapse {
        my $original = 'One night-it was on the twentieth of March, 1888-I was returning';
        my $en = $sc.encode($original, :$collapse);
        my $de = $sc.decode($en);
        say '';
        say "Original: $original";
        say "Encoded:  $en";
        say "Decoded:  $de";
    }
}
