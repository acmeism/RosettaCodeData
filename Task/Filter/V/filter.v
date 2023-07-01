[even? dup 2 / >int 2 * - zero?].

[1 2 3 4 5 6 7 8 9] [even?] filter
=[2 4 6 8]
