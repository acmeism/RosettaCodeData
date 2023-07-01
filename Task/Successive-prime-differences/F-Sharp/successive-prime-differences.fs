// Successive primes. Nigel Galloway: May 6th., 2019
let sP n=let sP=pCache|>Seq.takeWhile(fun n->n<1000000)|>Seq.windowed(Array.length n+1)|>Seq.filter(fun g->g=(Array.scan(fun n g->n+g) g.[0] n))
         printfn "sP %A\t-> Min element = %A Max element = %A of %d elements" n (Seq.head sP) (Seq.last sP) (Seq.length sP)
List.iter sP [[|2|];[|1|];[|2;2|];[|2;4|];[|4;2|];[|6;4;2|]]
