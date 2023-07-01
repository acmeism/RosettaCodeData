// lazy sequence of integers starting with i
let rec integers i =
  seq { yield i
        yield! integers (i+1) }

Seq.iter (printfn "%d") (integers 1)
