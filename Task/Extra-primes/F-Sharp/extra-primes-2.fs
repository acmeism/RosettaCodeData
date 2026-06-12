primes64() |> Seq.filter izXprime |> Seq.takeWhile((>) 10000L) |> Seq.iteri(printfn "%3d->%d")
