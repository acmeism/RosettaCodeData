sub MAIN (Bool :$b, Str :$s = '', Int :$n = 0, *@rest) {
    say "Bool: $b";
    say "Str: $s";
    say "Num: $n";
    say "Rest: @rest[]";
}
