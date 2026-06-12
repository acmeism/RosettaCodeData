##
uses school;

for var n := 1 to 50 do divisors(n).Aggregate(1,(p,x) -> p*x).Print;
