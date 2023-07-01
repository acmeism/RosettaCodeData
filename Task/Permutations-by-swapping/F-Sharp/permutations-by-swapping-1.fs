(*Implement Johnson-Trotter algorithm
  Nigel Galloway January 24th 2017*)
module Ring
let PlainChanges (N:'n[]) = seq{
  let gn  = [|for n in N -> 1|]
  let ni  = [|for n in N -> 0|]
  let gel = Array.length(N)-1
  yield N
  let rec _Ni g e l = seq{
    match (l,g) with
    |_ when l<0   -> gn.[g] <- -gn.[g]; yield! _Ni (g-1) e (ni.[g-1] + gn.[g-1])
    |(1,0)        -> ()
    |_ when l=g+1 -> gn.[g] <- -gn.[g]; yield! _Ni (g-1) (e+1) (ni.[g-1] + gn.[g-1])
    |_ -> let n = N.[g-ni.[g]+e];
          N.[g-ni.[g]+e] <- N.[g-l+e]; N.[g-l+e] <- n; yield N
          ni.[g] <- l; yield! _Ni gel 0 (ni.[gel] + gn.[gel])}
  yield! _Ni gel 0 1
}
