##
function IsPrime(n: integer) := (2..n.Sqrt.Trunc).All(i -> n.NotDivs(i));

(2..100).Where(IsPrime).Println
