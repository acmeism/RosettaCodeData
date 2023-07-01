// Smarandache-Wellin primes. Nigel Galloway: April 3rd., 2023
let izP(g,_,_,_)=let mutable g=System.Numerics.BigInteger.Parse g
                 Open.Numeric.Primes.MillerRabin.IsProbablePrime &g
let fN g="0123456789"+g|>Seq.countBy id|>Seq.map(fun(_,g)->string(g-1))|>Seq.fold((+))""
let sw()=primes32()|>Seq.scan(fun(n,i,g,e)l->let a=string l in (n+a,l,g+1,e+(String.length a)))("",0,0,0)|>Seq.skip 1
sw()|>Seq.filter izP|>Seq.take 3|>Seq.iter(fun(i,_,_,_)->printf "%s " i); printfn ""
sw()|>Seq.filter izP|>Seq.take 7|>Seq.iter(fun(_,n,g,l)->printfn "index %4d: digits %4d last prime %d" g l n); printfn ""
sw()|>Seq.map(fun(i,g,e,l)->(fN i,g,e,l))|>Seq.filter izP|>Seq.take 20|>Seq.iter(fun(n,_,g,_)->printfn $"index %4d{g}: prime %s{n}")
