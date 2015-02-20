sub insert(@a,$p,$e) { @a[^$p], $e, @a[$p..*] }

constant chess960 = eager gather for 0..3 -> $q {
    my @q = insert <♜ ♚ ♜>, $q, '♛';
    for 0 .. @q -> $n1 {
        my @n1 = insert @q, $n1, '♞';
        for $n1 ^.. @n1 -> $n2 {
            my @n2 = insert @n1, $n2, '♞';
            for 0 .. @n2 -> $b1 {
                my @b1 = insert @n2, $b1, '♝';
                for $b1+1, $b1+3 ...^ * > @b1 -> $b2 {
                    my @b2 = insert @b1, $b2, '♝';
                    take @b2.join;
                }
            }
        }
    }
}

CHECK { note "done compiling" }
note +chess960;
say chess960.pick;
