##
function IsPrime(n: integer) := (2..n.Sqrt.Round).All(i -> n.NotDivs(i));

(2..100).Where(IsPrime).Println
