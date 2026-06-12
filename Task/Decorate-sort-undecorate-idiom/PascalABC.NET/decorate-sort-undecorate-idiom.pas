##
function Schwartzian<T, TKey>(source: sequence of T; decorator: T-> TKey) :=
   source.Select(x -> (x, decorator(x)))
   .orderby(x -> x[1])
   .select(x -> x[0]);

var test: sequence of string := |'Rosetta', 'Code', 'is', 'a', 'programming', 'chrestomathy', 'site'|;
Schwartzian(test, x -> x.length).Println;
