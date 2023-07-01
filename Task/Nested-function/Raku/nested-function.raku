sub make-List ($separator = ') '){
    my $count = 1;

    sub make-Item ($item) { "{$count++}$separator$item" }

    join "\n", <first second third>».&make-Item;
}

put make-List('. ');
