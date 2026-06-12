// Ormiston pairs. Nigel Galloway: January 31st., 2023
let fG(n,g)=let i=Array.zeroCreate<int>10
            let rec fG n g=if g<10 then i[g]<-n i[g] 1 else i[g%10]<-n i[g%10] 1; fG n (g/10)
            fG (+) n; fG (-) g; Array.forall ((=)0) i
let oPairs n=n|>Seq.pairwise|>Seq.filter fG
primes32()|>oPairs|>Seq.take 30|>Seq.iter(printf "%A "); printfn ""
printfn $"<1 million: %d{primes32()|>Seq.takeWhile((>)1000000)|>oPairs|>Seq.length}"
printfn $"<10 million: %d{primes32()|>Seq.takeWhile((>)10000000)|>oPairs|>Seq.length}"
printfn $"<100 million: %d{primes32()|>Seq.takeWhile((>)100000000)|>oPairs|>Seq.length}"
printfn $"<1 billion: %d{primes32()|>Seq.takeWhile((>)1000000000)|>oPairs|>Seq.length}"
