##
uses school;

for var n := 1 to 100 do divisors(n).Aggregate(0,(p,x) -> p+x).Print;
