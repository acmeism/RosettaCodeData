printfn "zeroes"; Seq.unfold(fun n->Some(n,0I))1I|>Seq.take 15|>Boustrophedon|>Seq.iter(printf "%A "); printfn ""
let n=sprintf $"%A{Seq.unfold(fun n->Some(n,0I))1I|>Boustrophedon|>Seq.item 999}" in printfn "%s ... %s  (%d digits)" n[0..19] n[n.Length-20..n.Length] (n.Length)
printfn "ones"; Seq.unfold(fun n->Some(n,n))1I|>Seq.take 15|>Boustrophedon|>Seq.iter(printf "%A "); printfn ""
let n=sprintf $"%A{Seq.unfold(fun n->Some(n,n))1I|>Boustrophedon|>Seq.item 999}" in printfn "%s ... %s  (%d digits)" n[0..19] n[n.Length-20..n.Length] (n.Length)
printfn "1,-1,1,-1....."; Seq.unfold(fun n->Some(n,-n))1I|>Boustrophedon|>Seq.take 15|>Seq.iter(printf "%A "); printfn ""
let n=sprintf $"%A{Seq.unfold(fun n->Some(n,-n))1I|>Boustrophedon|>Seq.item 999}" in printfn "%s ... %s  (%d digits)" n[0..19] n[n.Length-20..n.Length] (n.Length)
printfn "factorials"; Seq.unfold(fun(n,g)->Some(n,(n*g,g+1I)))(1I,1I)|>Boustrophedon|>Seq.take 15|>Seq.iter(printf "%A "); printfn ""
let n=sprintf $"%A{Seq.unfold(fun(n,g)->Some(n,(n*g,g+1I)))(1I,1I)|>Boustrophedon|>Seq.item 999}" in printfn "%s ... %s  (%d digits)" n[0..19] n[n.Length-20..n.Length] (n.Length)
printfn "primes"; let p=primes() in Seq.initInfinite(fun _->bigint(p()))|>Boustrophedon|>Seq.take 15|>Seq.iter(printf "%A "); printfn ""
let n=sprintf $"%A{let p=primes() in Seq.initInfinite(fun _->bigint(p()))|>Boustrophedon|>Seq.item 999}" in printfn "%s ... %s  (%d digits)" n[0..19] n[n.Length-20..n.Length] (n.Length)

