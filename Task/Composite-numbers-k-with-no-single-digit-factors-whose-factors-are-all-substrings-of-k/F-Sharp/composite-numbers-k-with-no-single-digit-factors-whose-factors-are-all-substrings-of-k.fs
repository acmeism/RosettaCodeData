// Composite numbers k with no single digit factors whose factors are all substrings of k.  Nigel Galloway: January 28th., 2022
let fG n g=let rec fN i g e l=match i<g,g=0L,i%10L=g%10L with (true,_,_)->false |(_,true,_)->true |(_,_,true)->fN(i/10L)(g/10L) e l |_->fN l e e (l/10L) in fN n g g (n/10L)
let fN(g:int64)=Open.Numeric.Primes.Prime.Factors g|>Seq.skip 1|>Seq.distinct|>Seq.forall(fun n->fG g n)
Seq.unfold(fun n->Some(n|>List.filter(fun(n:int64)->not(Open.Numeric.Primes.Prime.Numbers.IsPrime &n) && fN n),n|>List.map((+)210L)))([1L..2L..209L]
|>List.filter(fun n->n%3L>0L && n%5L>0L && n%7L>0L))|>Seq.concat|>Seq.skip 1|>Seq.take 20|>Seq.iter(printfn "%d")
