// Return true if prime n is a long prime. Nigel Galloway: September 25th., 2018
let fN n g = let rec fN i g e l = match e with | 0UL                -> i
                                               | _ when e%2UL = 1UL -> fN ((i*g)%l) ((g*g)%l) (e/2UL) l
                                               | _                  -> fN i ((g*g)%l) (e/2UL) l
             fN 1UL 10UL (uint64 g) (uint64 n)
let isLongPrime n=Seq.length (factors (n-1) |> Seq.filter(fun g->(fN n g)=1UL))=1
