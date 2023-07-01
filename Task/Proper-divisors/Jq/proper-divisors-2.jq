"The proper divisors of the numbers 1 to 10 inclusive are:",
(range(1;11) as $i | "\($i): \( [ $i | proper_divisors] )"),
"",
"The pair consisting of the least number in the range 1 to 20,000 with",
"the maximal number proper divisors together with the corresponding",
"count of proper divisors is:",
most_proper_divisors(20000)
