let primeZ fN  =primes()|>Seq.unfold(fun g-> Some(fN(g()), g))
let primesI()  =primeZ bigint
let primes64() =primeZ int64
let primes32() =primeZ int32
let pCache     =Seq.cache(primes32())
let isPrime   g=if g<2  then false else let mx=int(sqrt(float g)) in pCache|>Seq.takeWhile(fun n->n<=mx)|>Seq.forall(fun n->g%n>0)
let isPrime64 g=if g<2L then false else let mx=int(sqrt(float g)) in pCache|>Seq.takeWhile(fun n->n<=mx)|>Seq.forall(fun n->g%(int64 n)>0L)
