#=
Here we show all the 128 < numbers < 400 can be expressed as a sum of distinct squares. Now
11 * 11 < 128 < 12 * 12. It is also true that we need no square less than 144 (12 * 12) to
reduce via subtraction of squares all the numbers above 400 to a number > 128 and < 400 by
subtracting discrete squares of numbers over 12, since the interval between such squares can
be well below 128: for example, |14^2 - 15^2| is 29. So, we can always find a serial subtraction
of discrete integer squares from any number > 400 that targets the interval between 129 and
400. Once we get to that interval, we already have shown in the program below that we can
use the remaining squares under 400 to complete the remaining sum.
=#

using Combinatorics

squares = [n * n for n in 1:20]

possibles = [n for n in 1:500 if all(combo -> sum(combo) != n, combinations(squares))]

println(possibles)
