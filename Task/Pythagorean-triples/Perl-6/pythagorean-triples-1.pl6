constant limit = 20;

for [X] [^limit] xx 3 -> \a, \b, \c {
    say [a, b, c] if a < b < c and a**2 + b**2 == c**2
}
