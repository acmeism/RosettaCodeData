// Partition an integer as the sum of n primes. Nigel Galloway: November 27th., 2017
let rcTask n ng =
  let rec fN i g e l = seq{
    match i with
    |1 -> if isPrime g then yield Some (g::e) else yield None
    |_ -> yield! Seq.mapi (fun n a->fN (i-1) (g-a) (a::e) (Seq.skip (n+1) l)) (l|>Seq.takeWhile(fun n->(g-n)>n))|>Seq.concat}
  match fN n ng [] primes |> Seq.tryPick id with
    |Some n->printfn "%d is the sum of %A" ng n
    |_     ->printfn "No Solution"
