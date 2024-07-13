##
var (x,y,z) := (+5,-5,-2);
var (one,three,seven) := (1,3,7);

var seq := (-three .. Round(3 ** 3)).Step(three)
           + (-seven .. +seven).Step(x)
           + (555 .. 550 - y)
           + (22 .. -28).Step(-three)
           + (1927 .. 1939)
           + (x .. y).Step(z)
           + (Round(11 ** x) .. Round(11 ** x) + one);

var sum := seq.Sum(x -> Abs(x));

var prod := 1;
foreach var t in seq do
  if (Abs(prod) < 2bi ** 27) and (t <> 0) then
    prod *= t;
Println('sum =',sum);
Println('prod =',prod);
