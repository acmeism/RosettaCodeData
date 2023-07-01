// Frugal, equidigital, and wasteful numbers. Nigel Galloway: July 26th., 2022
let rec fG n g=match g/10L with 0L->n+1 |g->fG(n+1) g
let fN(g:int64)=Open.Numeric.Primes.Extensions.PrimeExtensions.PrimeFactors g|>Seq.skip 1|>Seq.countBy id|>Seq.sumBy(fun(n,g)->fG 0 n + if g<2 then 0 else fG 0 g)
let Frugal,Equidigital,Wasteful=let FEW n=Seq.initInfinite((+)2)|>Seq.filter(fun g->n(fG 0 g)(fN g)) in (("Frugal",FEW(>)),("Equidigital",seq{yield 1; yield! FEW(=)}),("Wasteful",FEW(<)))
[Frugal;Equidigital;Wasteful]|>List.iter(fun(n,g)->printf $"%s{n}: 10 thousandth is %d{Seq.item 9999 g}; There are %d{Seq.length (g|>Seq.takeWhile((>)1000000))} < 1 million\n First 50: "; g|>Seq.take 50|>Seq.iter(printf "%d "); printfn "")
