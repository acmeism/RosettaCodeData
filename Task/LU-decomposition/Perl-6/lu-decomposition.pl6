for (  [1, 3, 5], # Test Matrices
       [2, 4, 7],
       [1, 1, 0]
    ),
    (  [11,  9, 24,  2],
       [ 1,  5,  2,  6],
       [ 3, 17, 18,  1],
       [ 2,  5,  7,  1]
    )
    -> @test {
    say-it 'A Matrix', @test;
    say-it( $_[0], @($_[1]) ) for 'P Matrix', 'Aʼ Matrix', 'L Matrix', 'U Matrix' Z, lu @test;
}

sub lu (@a) {
    die unless @a.&is-square;
    my $n = +@a;
    my @P = pivotize @a;
    my @Aʼ = mmult @P, @a;
    my @L = matrix-ident $n;
    my @U = matrix-zero  $n;
    for ^$n -> $i {
        for ^$n -> $j {
            if $j >= $i {
                @U[$i][$j] =  @Aʼ[$i][$j] - [+] map { @U[$_][$j] * @L[$i][$_] }, ^$i
            } else {
                @L[$i][$j] = (@Aʼ[$i][$j] - [+] map { @U[$_][$j] * @L[$i][$_] }, ^$j) / @U[$j][$j];
            }
        }

    }
    return @P, @Aʼ, @L, @U;
}

sub pivotize (@m) {
    my $size = +@m;
    my @id = matrix-ident $size;
    for ^$size -> $i {
        my $max = @m[$i][$i];
        my $row = $i;
        for $i ..^ $size -> $j {
            if @m[$j][$i] > $max {
                $max = @m[$j][$i];
                $row = $j;
            }
        }
        if $row != $i {
            @id[$row, $i] = @id[$i, $row]
        }
    }
    @id
}

sub is-square (@m) { so @m == all @m[*] }

sub matrix-zero ($n, $m = $n) { map { [ flat 0 xx $n ] }, ^$m }

sub matrix-ident ($n) { map { [ flat 0 xx $_, 1, 0 xx $n - 1 - $_ ] }, ^$n }

sub mmult(@a,@b) {
    my @p;
    for ^@a X ^@b[0] -> ($r, $c) {
        @p[$r][$c] += @a[$r][$_] * @b[$_][$c] for ^@b;
    }
    @p
}

sub rat-int ($num) {
    return $num unless $num ~~ Rat;
    return $num.narrow if $num.narrow.WHAT ~~ Int;
    $num.nude.join: '/';
}

sub say-it ($message, @array) {
    say "\n$message";
    $_».&rat-int.fmt("%7s").say for @array;
}
