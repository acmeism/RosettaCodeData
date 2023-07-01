// Circular primes - Nigel Galloway: September 13th., 2021
let fG n g=let rec fG y=if y=g then true else if y>g && isPrime y then fG(10*(y%n)+y/n) else false in fG(10*(g%n)+g/n)
let rec fN g l=seq{let g=[for n in g do for g in [1;3;7;9] do let g=n*10+g in yield g] in yield! g|>List.filter(fun n->isPrime n && fG l n); yield! fN g (l*10)}
let circP()=seq{yield! [2;3;5;7]; yield! fN [1;3;7;9] 10}
circP()|> Seq.take 19 |>Seq.iter(printf "%d "); printfn ""
printf "The first 5 repunit primes are "; rUnitP(10)|>Seq.take 5|>Seq.iter(fun n->printf $"R(%d{n}) "); printfn ""
