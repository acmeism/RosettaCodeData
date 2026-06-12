//3 Sandwich Primes. Nigel Galloway: July 25th., 2021
primes32()|>Seq.takeWhile((>)4000)|>Seq.filter(fun n->n%10=3 && (n=3||(n>29 && n<40)||(n>299 && n<400)||n>2999))|>Seq.iter(printf "%d "); printfn ""
