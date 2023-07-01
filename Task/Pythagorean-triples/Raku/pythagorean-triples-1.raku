constant limit = 100;

for [X] [^limit] xx 3 -> (\a, \b, \c) {
    say [a, b, c] if a < b < c and a + b + c <= limit and a*b + b*b == c*c
}
