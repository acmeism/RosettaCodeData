// Palindromic numbers in bases 2,4, and 16. Nigel Galloway: June 25th., 2021
let fG n g=let rec fG n g=[yield n%g; if n>=g then yield! fG(n/g) g] in let n=fG n g in n=List.rev n
Seq.initInfinite id|>Seq.takeWhile((>)25000)|>Seq.filter(fun g->fG g 16 && fG g 4 && fG g 2)|>Seq.iter(printf "%d "); printfn ""
