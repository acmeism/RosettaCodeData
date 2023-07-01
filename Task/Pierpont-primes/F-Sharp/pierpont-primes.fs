// Pierpont primes . Nigel Galloway: March 19th., 2021
let fN g=let mutable g=g in ((fun()->g),fun()->g<-g+g;())
let fG y=let rec fG n g=seq{match g|>List.minBy(fun(n,_)->n()) with (f,s) when f()=n->yield f()+y; s(); yield! fG(n*3)(fN(n*3)::g)
                                                                   |(f,s)           ->yield f()+y; s(); yield! fG n g}
         seq{yield! fG 1 [fN 1]}|>Seq.filter isPrime
let pierpontT1,pierpontT2=fG 1,fG -1

pierpontT1|>Seq.take 50|>Seq.iter(printf "%d "); printfn ""
pierpontT2|>Seq.take 50|>Seq.iter(printf "%d "); printfn ""
