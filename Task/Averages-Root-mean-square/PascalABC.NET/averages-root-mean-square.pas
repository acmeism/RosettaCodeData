##
function rootmeansquare(n: array of integer) :=
   Sqrt(n.Sum(x -> x * x) / n.Length);

rootmeansquare(Arr(1..10)).Println;
