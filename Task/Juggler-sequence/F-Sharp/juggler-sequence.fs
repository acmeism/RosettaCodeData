// Juggler sequence. Nigel Galloway: August 19th., 2021
let J n=Seq.unfold(fun(n,i,g,l)->if n=1I then None else let e=match n.IsEven with true->Isqrt n |_->Isqrt(n**3) in Some((i,g,l),if e>i then (e,e,l+1,l+1) else (e,i,g,l+1)))(n,n,0,0)|>Seq.last
printfn " n  l[n] i[n]  h[n]\n___________________"; [20I..39I]|>Seq.iter(fun n->let i,g,l=J n in printfn $"%d{int n}%5d{l+1}%5d{g}   %A{i}")
printfn "      n  l[n] i[n]  d[n]\n________________________"; [113I;173I;193I;2183I;11229I;15065I;15845I;30817I]|>Seq.iter(fun n->let i,g,l=J n in printfn $"%8d{int n}%5d{l+1}%5d{g}   %d{(bigint.Log10>>int>>(+)1) i}")
