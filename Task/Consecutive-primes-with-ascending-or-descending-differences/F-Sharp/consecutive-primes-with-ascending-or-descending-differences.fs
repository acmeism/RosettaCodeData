// Longest ascending and decending sequences of difference between consecutive primes: Nigel Galloway. April 5th., 2021
let fN g fW=primes32()|>Seq.takeWhile((>)g)|>Seq.pairwise|>Seq.fold(fun(n,i,g)el->let w=fW el in match w>n with true->(w,el::i,g) |_->(w,[el],if List.length i>List.length g then i else g))(0,[],[])
for i in [1;2;6;12;18;100] do let _,_,g=fN(i*1000000)(fun(n,g)->g-n) in printfn "Longest ascending upto %d000000->%d:" i (g.Length+1); g|>List.rev|>List.iter(fun(n,g)->printf "%d (%d) %d " n (g-n) g); printfn ""
                              let _,_,g=fN(i*1000000)(fun(n,g)->n-g) in printfn "Longest decending upto %d000000->%d:" i (g.Length+1); g|>List.rev|>List.iter(fun(n,g)->printf "%d (%d) %d " n (g-n) g); printfn ""
