// Abundant odd numbers. Nigel Galloway: August 1st., 2021
let fN g=Seq.initInfinite(int64>>(+)1L)|>Seq.takeWhile(fun n->n*n<=g)|>Seq.filter(fun n->g%n=0L)|>Seq.sumBy(fun n->let i=g/n in n+(if i=n then 0L else i))
let aon n=Seq.initInfinite(int64>>(*)2L>>(+)n)|>Seq.map(fun g->(g,fN g))|>Seq.filter(fun(n,g)->2L*n<g)
aon 1L|>Seq.take 25|>Seq.iter(fun(n,g)->printfn "The sum of the divisors of %d is %d" n g)
let n,g=aon 1L|>Seq.item 999 in printfn "\nThe 1000th abundant odd number is %d. The sum of it's divisors is %d" n g
let n,g=aon 1000000001L|>Seq.head in printfn "\nThe first abundant odd number greater than 1000000000 is %d. The sum of it's divisors is %d" n g
