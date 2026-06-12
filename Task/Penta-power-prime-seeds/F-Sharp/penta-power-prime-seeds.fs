// Penta-power prime seeds. Nigel Galloway: April 5th., 2023
let fG n g=let n=bigint(n:int) in let n=n**g+n+1I in Open.Numeric.Primes.MillerRabin.IsProbablePrime &n
let fN(n,g)=Seq.initInfinite((+)n)|>Seq.filter(fun n->let g=fG n in g 0&&g 1&&g 2&&g 3&&g 4)|>Seq.mapi(fun n g->(n,g))|>Seq.find(snd>>(<)g)
Seq.initInfinite((*)2>>(+)1)|>Seq.filter(fun n->let g=fG n in g 0&&g 1&&g 2&&g 3&&g 4)|>Seq.take 30|>Seq.iter(printf "%d "); printfn "\n"
[1000000..1000000..10000000]|>Seq.scan(fun(n,g,x) l->let i,e=fN(g,l) in (n+i,e,l))(0,0,0)|>Seq.skip 1|>Seq.iter(fun(n,g,l)->printfn $"First element over %8d{l} is %9d{g} at index %3d{n}")
