let strt = System.DateTime.Now.Ticks
for i = 1 to 8 do
  let n = pown 10 i // the item index below is zero based!
  printfn "The %dth prime is:  %A" n (primeZ int |> Seq.item (n - 1))
let timed = (System.DateTime.Now.Ticks - strt) / 10000L
printfn "All of the last took %d milliseconds." timed
