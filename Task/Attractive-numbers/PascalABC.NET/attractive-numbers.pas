##
uses School;

var attractive :=
  (1..120)
    .Where(n -> IsPrime(n.Factorize.Count))
    .ToList;

Println($'There are {attractive.Count} attractive numbers up to and including 120:');
Println(attractive);
