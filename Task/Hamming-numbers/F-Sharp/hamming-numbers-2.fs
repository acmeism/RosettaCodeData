let cNUMVALS = 1000000

type LazyList<'a> = Cons of 'a * Lazy<LazyList<'a>>

let hammings() =
  let rec merge (Cons(x, f) as xs) (Cons(y, g) as ys) =
    if x < y then Cons(x, lazy(merge (f.Force()) ys))
    else Cons(y, lazy(merge xs (g.Force())))
  let rec smult m (Cons(x, rxs)) =
    Cons(m * x, lazy(smult m (rxs.Force())))
  let rec first = smult 5I (Cons(1I, lazy first))
  let u s n =
    let rec r = merge s (smult n (Cons(1I, lazy r))) in r
  Seq.unfold (fun (Cons(hd, rst)) -> Some (hd, rst.Value))
             (Cons(1I, lazy(Seq.fold u first [| 3I; 2I |])))

[<EntryPoint>]
let main argv =
  printf "( "; hammings() |> Seq.take 20 |> Seq.iter (printf "%A "); printfn ")"
  printfn "%A" (hammings() |> Seq.item (1691 - 1))
  let strt = System.DateTime.Now.Ticks

  let rslt = (hammings()) |> Seq.item (cNUMVALS - 1)

  let stop = System.DateTime.Now.Ticks

  printfn "%A" rslt
  printfn "Found this last up to %d in %d milliseconds." cNUMVALS ((stop - strt) / 10000L)

  0 // return an integer exit code
