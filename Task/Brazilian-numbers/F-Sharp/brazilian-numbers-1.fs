// Generate Brazilian sequence. Nigel Galloway: August 13th., 2019
let isBraz α=let mutable n,i,g=α,α+1,1 in (fun β->(while (i*g)<β do if g<α-1 then g<-g+1 else (n<-n*α; i<-n+i; g<-1)); β=i*g)

let Brazilian()=let rec fN n g=seq{if List.exists(fun α->α n) g then yield n
                                   yield! fN (n+1) ((isBraz (n-1))::g)}
                fN 4 [isBraz 2]
