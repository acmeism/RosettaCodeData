// Unprimeable numbers. Nigel Galloway: May 4th., 2021
let rec fN i g e l=seq{yield! [0..9]|>Seq.map(fun n->n*g+e+l); if g>1 then let g=g/10 in yield! fN(i+g*(e/g)) g (e%g) i}
let     fG(n,g)=fN(n*(g/n)) n (g%n) 0|>Seq.exists(isPrime)
let uP()=let rec fN n g=seq{yield! {n..g-1}|>Seq.map(fun g->(n,g)); yield! fN(g)(g*10)} in fN 1 10|>Seq.filter(fG>>not)|>Seq.map snd
