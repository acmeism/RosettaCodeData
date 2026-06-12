// Find adjacents primes which difference is square integer . Nigel Galloway: November 23rd., 2021
primes32()|>Seq.takeWhile((>)1000000)|>Seq.pairwise|>Seq.filter(fun(n,g)->let n=g-n in let g=(float>>sqrt>>int)n in g>6 && n=g*g)|>Seq.iter(printfn "%A")
