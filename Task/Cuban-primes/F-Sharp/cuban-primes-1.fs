// Generate cuban primes. Nigel Galloway: June 9th., 2019
let cubans=Seq.unfold(fun n->Some(n*n*n,n+1L)) 1L|>Seq.pairwise|>Seq.map(fun(n,g)->g-n)|>Seq.filter(isPrime64)
let cL=let g=System.Globalization.CultureInfo("en-GB") in (fun (n:int64)->n.ToString("N0",g))
