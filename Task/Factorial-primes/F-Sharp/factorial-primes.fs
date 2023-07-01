// Factorial primes. Nigel Galloway: August 15th., 2022
let fN g=if Open.Numeric.Primes.MillerRabin.IsProbablePrime &g then Some(g) else None
let fp()=let rec fG n g=seq{let n=n*g in yield (fN(n-1I),-1,g); yield (fN(n+1I),1,g); yield! fG n (g+1I)} in fG 1I 1I|>Seq.filter(fun(n,_,_)->Option.isSome n)
fp()|>Seq.iteri(fun i (n,g,l)->printfn $"""%2d{i+1}: %3d{int l}!%+d{g} -> %s{let n=string(Option.get n) in if n.Length<41 then n else n[0..19]+".."+n[n.Length-20..]+" ["+string(n.Length)+" digits]"}""")
