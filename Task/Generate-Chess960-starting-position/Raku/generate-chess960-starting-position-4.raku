constant chess960 = gather for 0..3 -> $q {
    (my @q = <♜ ♚ ♜>).splice($q, 0, '♛');
    for 0 .. @q -> $n1 {
        (my @n1 = @q).splice($n1, 0, '♞');
        for $n1 ^.. @n1 -> $n2 {
            (my @n2 = @n1).splice($n2, 0, '♞');
            for 0 .. @n2 -> $b1 {
                (my @b1 = @n2).splice($b1, 0, '♝');
                for $b1+1, $b1+3 ...^ * > @b1 -> $b2 {
                    (my @b2 = @b1).splice($b2, 0, '♝');
                    take @b2.join;
                }
            }
        }
    }
}

CHECK { note "done compiling" }
note +chess960;
say chess960.pick;
