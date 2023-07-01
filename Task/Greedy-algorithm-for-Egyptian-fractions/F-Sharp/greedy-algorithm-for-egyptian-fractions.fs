// Greedy algorithm for Egyptian fractions. Nigel Galloway: February 1st., 2023
open Mathnet.Numerics
let fN(g:BigRational)=match bigint.DivRem(g.Denominator,g.Numerator) with (n,g) when g=0I->n |(n,_)->n+1I
let fG(n:BigRational)=Seq.unfold(fun(g:BigRational)->if g.Numerator=0I then None else let i=fN g in Some(i,(g-1N/(BigRational.FromBigInt i))))(n)
let fL(n:bigint,g:seq<bigint>)=printf "%A" n; g|>Seq.iter(printf "+1/%A"); printfn ""
let f2ef(i:BigRational)=let n,g=bigint.DivRem(i.Numerator,i.Denominator) in (n,fG(BigRational.FromBigIntFraction(g,i.Denominator)))
[43N/48N;5N/121N;2014N/59N]|>List.iter(f2ef>>fL)
let n,_=List.allPairs [1N..99N] [1N..99N]|>Seq.map(fun(n,g)->let n=n/g in (n,f2ef n))|>Seq.maxBy(fun(_,(n,g))->Seq.length g + if n>0I then 1 else 0) in printf "%A->" n; (f2ef>>fL)n
let n,_=List.allPairs [1N..999N] [1N..999N]|>Seq.map(fun(n,g)->let n=n/g in (n,f2ef n))|>Seq.maxBy(fun(_,(n,g))->Seq.length g + if n>0I then 1 else 0) in printf "%A->" n; (f2ef>>fL)n
let n,_=List.allPairs [1N..99N] [1N..99N]|>Seq.map(fun(n,g)->let n=n/g in (n,f2ef n))|>Seq.maxBy(fun(_,(n,g))->if Seq.isEmpty g then 0I else Seq.max g) in printf "%A->" n; (f2ef>>fL)n
let n,_=List.allPairs [1N..999N] [1N..999N]|>Seq.map(fun(n,g)->let n=n/g in (n,f2ef n))|>Seq.maxBy(fun(_,(n,g))->if Seq.isEmpty g then 0I else Seq.max g) in printf "%A->" n; (f2ef>>fL)n
