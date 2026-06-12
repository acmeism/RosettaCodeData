// L-system. Nigel Galloway: April 1th., 2024
type rabbit= M|I
let rules=function I->[M] |M->[M;I]
let L axiom rules=Seq.unfold(fun n->Some(n,n|>Seq.map(rules)|>Seq.concat)) axiom
L [I] rules|>Seq.take 6|>Seq.iter(fun n->n|>Seq.iter(printf "%A");printfn "")
