    my @list = lazy gather for ^100 -> $i {
        if $i.is-prime {
            say "Taking prime $i";
            take $i;
        }
    }

    say @list[5];
