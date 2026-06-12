""" Rosetta Code task rosettacode.org/wiki/Sub-unit_squares """

issquare(n::Integer) = isqrt(n)^2 == n
from_subsquare(n) = (d = digits(n); all( x -> x < 9, d) && issquare(evalpoly(10, d .+ 1)))
println("Subunit squares up to 10^12: ",
   pushfirst!([evalpoly(10, digits(i^2) .+ 1) for i in 5:10:10^6 if from_subsquare(i^2)], 1))
