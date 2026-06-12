// Erdős Primes. Nigel Galloway: March 22nd., 2021
let rec fN g=function 1->g |n->fN(g*n)(n-1)
let rec fG n g=seq{let i=fN 1 n in if i<g then yield (isPrime>>not)(g-i); yield! fG(n+1) g}
let eP()=primes32()|>Seq.filter(fG 1>>Seq.forall id)
eP()|>Seq.takeWhile((>)2500)|>Seq.iter(printf "%d "); printfn "\n\n7875th Erdős prime is %d" (eP()|>Seq.item 7874)
