// Sylvester's sequence: Nigel Galloway. June 7th., 2021
let S10=Seq.unfold(fun(n,g)->printfn "*%A %A" n g; Some(n,(n*g+1I,n*g) ) )(2I,1I)|>Seq.take 10|>List.ofSeq
S10|>List.iteri(fun n g->printfn "%2d -> %A" (n+1) g)
let n,g=S10|>List.fold(fun(n,g) i->(n*i+g,g*i))(0I,1I) in printfn "\nThe sum of the reciprocals of S10 is \n%A/\n%A" n g
