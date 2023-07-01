// Wilsons theorem. Nigel Galloway: August 11th., 2020
let wP(n,g)=(n+1I)%g=0I
let fN=Seq.unfold(fun(n,g)->Some((n,g),((n*g),(g+1I))))(1I,2I)|>Seq.filter wP
fN|>Seq.take 120|>Seq.iter(fun(_,n)->printf "%A " n);printfn "\n"
fN|>Seq.skip 999|>Seq.take 15|>Seq.iter(fun(_,n)->printf "%A " n);printfn ""
