// Wilson primes. Nigel Galloway: July 31st., 2021
let rec fN g=function n when n<2I->g |n->fN(n*g)(n-1I)
let fG (n:int)(p:int)=let g,p=bigint n,bigint p in (((fN 1I (g-1I))*(fN 1I (p-g))-(-1I)**n)%(p*p))=0I
[1..11]|>List.iter(fun n->printf "%2d -> " n; let fG=fG n in pCache|>Seq.skipWhile((>)n)|>Seq.takeWhile((>)11000)|>Seq.filter fG|>Seq.iter(printf "%d "); printfn "")
