sub middle-three($n) {
    given $n.abs {
        when .chars < 3  { "$n is too short" }
        when .chars %% 2 { "$n has an even number of digits" }
        default          { "The three middle digits of $n are: ", .substr: (.chars - 3)/2, 3 }
    }
}

say middle-three($_) for <
    123 12345 1234567 987654321 10001 -10001 -123 -100 100 -12345
    1 2 -1 -10 2002 -2002 0
>;
