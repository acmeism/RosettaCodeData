// Jacobsthal numbers: Nigel Galloway January 10th., 2023
let J,JL=let fN g ()=Seq.unfold(fun(n,g)->Some(n,(g,g+2UL*n)))(g,1UL) in (fN 0UL,fN 2UL)
printf "First 30 Jacobsthal are "; J()|>Seq.take 30|>Seq.iter(printf "%d "); printfn ""
printf "First 30 Jacobsthal-Lucas are "; JL()|>Seq.take 30|>Seq.iter(printf "%d "); printfn ""
printf "First 20 Jacobsthal Oblong are "; J()|>Seq.pairwise|>Seq.take 20|>Seq.iter(fun(n,g)->printf "%d " (n*g)); printfn ""
let fN g= Open.Numeric.Primes.MillerRabin.IsPrime &g
printf "First 10 Jacobsthal Primes are "; J()|>Seq.filter fN|>Seq.take 10|>Seq.iter(printf "%d "); printfn ""
