// The sieve of Sundaram. Nigel Galloway: August 7th., 2021
let sPrimes()=
  let sSieve=System.Collections.Generic.Dictionary<int,(unit -> int) list>()
  let rec fN g=match g with h::t->(let n=h() in if sSieve.ContainsKey n then sSieve.[n]<-h::sSieve.[n] else sSieve.Add(n,[h])); fN t|_->()
  let     fI n=if sSieve.ContainsKey n then fN sSieve.[n]; sSieve.Remove n|>ignore; None else Some(2*n+1)
  let     fG n g=let mutable n=n in (fun()->n<-n+g; n)
  let     fE n g=if not(sSieve.ContainsKey n) then sSieve.Add(n,[fG n g]) else sSieve.[n]<-(fG n g)::sSieve.[g]
  let     fL    =let mutable n,g=4,3 in (fun()->n<-n+3; g<-g+2; fE (n+g) g; n)
  sSieve.Add(4,[fL]); Seq.initInfinite((+)1)|>Seq.choose fI

sPrimes()|>Seq.take 100|>Seq.iter(printf "%d "); printfn ""
printfn "The millionth Sundaram prime is %d" (Seq.item 999999 (sPrimes()))
