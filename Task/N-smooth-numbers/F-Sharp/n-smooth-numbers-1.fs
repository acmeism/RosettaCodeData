let primesTo n =
  if n < 3 then (if n < 2 then Seq.empty else Seq.singleton 2) else
  let rec oddPrimesTo on =
    let sqrtlmt = double on |> sqrt |> truncate |> int
    let obps = if sqrtlmt < 3 then Seq.empty else oddPrimesTo sqrtlmt
    let ns = [ 3 .. 2 .. on ]
    let filtfnc fn = Seq.forall (fun bp -> bp * bp > fn ||
                                             fn % bp <> 0) obps
    Seq.filter filtfnc ns
  Seq.append  (Seq.singleton 2)  (oddPrimesTo n)

type LazyList<'a> = Cons of 'a * Lazy<LazyList<'a>>

// Doesn't need to be that efficient for the task...
#nowarn "40" // don't need to warn for recursive values
let smooths p =
  if p < 2 then Seq.singleton (bigint 1) else
  let smthprms = primesTo p |> Seq.rev |> Seq.map bigint
  let frstp = Seq.head smthprms
  let rstps = Seq.tail smthprms
  let frstll =
    let rec nxt n =
      Cons(n, lazy nxt (n * frstp))
    nxt frstp
  let smult m lzylst =
    let rec smlt (Cons(x, rxs)) =
      Cons(m * x, lazy(smlt (rxs.Force())))
    smlt lzylst
  let rec merge (Cons(x, f) as xs) (Cons(y, g) as ys) =
    if x < y then Cons(x, lazy(merge (f.Force()) ys))
    else Cons(y, lazy(merge xs (g.Force())))
  let u s n =
    let rec r = merge s (smult n (Cons(1I, lazy r))) in r
  Seq.unfold (fun (Cons(hd, rst)) -> Some (hd, rst.Value))
             (Cons(1I, lazy(Seq.fold u frstll rstps)))

let strt = System.DateTime.Now.Ticks

primesTo 29 |> Seq.iter (fun p ->
  printfn "First 25 %d-smooth:" p
  smooths p |> Seq.take 25 |> Seq.toList |> printfn "%A\r\n")

primesTo 29 |> Seq.skip 1 |> Seq.iter (fun p ->
  printfn "The first three from the 3,000th %d-smooth numbers are:" p
  smooths p |> Seq.skip 2999 |> Seq.take 3 |> Seq.toList |> printfn "%A\r\n")

primesTo 521 |> Seq.skipWhile ((>) 503) |> Seq.iter (fun p ->
  printfn "The first 20 30,000th up %d-smooth numbers are:" p
  smooths p |> Seq.skip 29999 |> Seq.take 20 |> Seq.toList |> printfn "%A\r\n")

let stop = System.DateTime.Now.Ticks
printfn "This took %d milliseconds." ((stop - strt) / 10000L)
