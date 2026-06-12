// Coprime triplets: Nigel Galloway. May 12th., 2021
let rec fN g=function 0->g=1 |n->fN n (g%n)
let rec fG t n1 n2=seq{let n=seq{1..0x0FFFFFFF}|>Seq.find(fun n->not(List.contains n t) && fN n1 n && fN n2 n) in yield n; yield! cT(n::t) n2 n}
let cT=seq{yield 1; yield 2; yield! fG [1;2] 1 2}
cT|>Seq.takeWhile((>)50)|>Seq.iter(printf "%d "); printfn ""
