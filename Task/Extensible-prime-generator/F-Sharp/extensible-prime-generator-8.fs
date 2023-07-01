printfn "The first 20 primes are:  %s"
  ( primesSeq() |> Seq.take 20
      |> Seq.fold (fun s p -> s + string p + " ") "" )
printfn "The primes from 100 to 150 are:  %s"
  ( primesSeq() |> Seq.skipWhile ((>) (prime 100))
      |> Seq.takeWhile ((>=) (prime 150))
      |> Seq.fold (fun s p -> s + string p + " ") "" )
printfn "The number of primes from 7700 to 8000 are:  %d"
  ( primesSeq() |> Seq.skipWhile ((>) (prime 7700))
      |> Seq.takeWhile ((>=) (prime 8000)) |> Seq.length )
let strt = System.DateTime.Now.Ticks
for i = 1 to 8 do
  let n = pown 10 i // the item index below is zero based!
  printfn "The %dth prime is:  %A" n (primesSeq() |> Seq.item (n - 1))
let timed = (System.DateTime.Now.Ticks - strt) / 10000L
printfn "All of the last took %d milliseconds." timed
