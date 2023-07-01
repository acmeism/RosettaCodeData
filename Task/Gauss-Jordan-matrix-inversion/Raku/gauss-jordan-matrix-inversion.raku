sub gauss-jordan-invert (@m where &is-square) {
    ^@m .map: { @m[$_].append: identity(+@m)[$_] };
    @m.&rref[*]»[+@m .. *];
}

sub is-square (@m) { so @m == all @m[*] }

sub identity ($n) { [ 1, |(0 xx $n-1) ], *.rotate(-1).Array ... *.tail }

# reduced row echelon form (from 'Gauss-Jordan elimination' task)
sub rref (@m) {
    my ($lead, $rows, $cols) = 0, @m, @m[0];

    for ^$rows -> $r {
        $lead < $cols or return @m;
        my $i = $r;
        until @m[$i;$lead] {
            ++$i == $rows or next;
            $i = $r;
            ++$lead == $cols and return @m;
        }
        @m[$i, $r] = @m[$r, $i] if $r != $i;
        @m[$r] »/=» $ = @m[$r;$lead];
        for ^$rows -> $n {
            next if $n == $r;
            @m[$n] »-=» @m[$r] »×» (@m[$n;$lead] // 0);
        }
        ++$lead;
    }
    @m
}
sub rat-or-int ($num) {
    return $num unless $num ~~ Rat|FatRat;
    return $num.narrow if $num.narrow ~~ Int;
    $num.nude.join: '/';
}

sub say_it ($message, @array) {
    my $max;
    @array.map: {$max max= max $_».&rat-or-int.comb(/\S+/)».chars};
    say "\n$message";
    $_».&rat-or-int.fmt(" %{$max}s").put for @array;
}

multi to-matrix ($str) { [$str.split(';').map(*.words.Array)] }
multi to-matrix (@array) { @array }

sub hilbert-matrix ($h) {
    [ (1..$h).map( -> $n { [ ($n ..^ $n + $h).map: { (1/$_).FatRat } ] } ) ]
}

my @tests =
    '1 2 3; 4 1 6; 7 8 9',
    '2 -1 0; -1 2 -1; 0 -1 2',
    '-1 -2 3 2; -4 -1 6 2; 7 -8 9 1; 1 -2 1 3',
    '1 2 3 4; 5 6 7 8; 9 33 11 12; 13 14 15 17',
    '3 1 8 9 6; 6 2 8 10 1; 5 7 2 10 3; 3 2 7 7 9; 3 5 6 1 1',

    # Test with a Hilbert matrix
    hilbert-matrix 10;

@tests.map: {
    my @matrix = .&to-matrix;
    say_it( " {'=' x 20} Original Matrix: {'=' x 20}", @matrix );
    say_it( ' Gauss-Jordan Inverted:', my @invert = gauss-jordan-invert @matrix );
    say_it( ' Re-inverted:', gauss-jordan-invert @invert».Array );
}
