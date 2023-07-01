// Earliest difference between prime gaps. Nigel Galloway: December 1st., 2021
let fN y=let i=System.Collections.Generic.SortedDictionary<int64,int64>()
         let fN()=i|>Seq.pairwise|>Seq.takeWhile(fun(n,g)->g.Key=n.Key+2L)|>Seq.tryFind(fun(n,g)->abs(n.Value-g.Value)>y)
         (fun(n,g)->let e=g-n in match i.TryGetValue(e) with (false,_)->i.Add(e,n); fN() |_->None)
[1..9]|>List.iter(fun g->let fN=fN(pown 10 g) in let n,i=(primes64()|>Seq.skip 1|>Seq.pairwise|>Seq.map fN|>Seq.find Option.isSome).Value
                         printfn $"%10d{pown 10 g} -> distance between start of gap %d{n.Key}=%d{n.Value} and start of gap %d{i.Key}=%d{i.Value} is %d{abs((n.Value)-(i.Value))}")
