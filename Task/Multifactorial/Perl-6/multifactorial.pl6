for 1 .. 5 -> $degree {
    sub mfact($n) { [*] $n, *-$degree ...^ * <= 0 };
    say "$degree: ", map &mfact, 1..10
}
