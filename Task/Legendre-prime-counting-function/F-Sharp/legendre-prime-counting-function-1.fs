let countPrimes (lmt: uint64) =
  if lmt < 3UL then (if lmt < 2UL then 0L else 1L) else
  let sqrtlmt = lmt |> float |> sqrt |> uint64
  let mxndx = (sqrtlmt - 3UL) / 2UL |> int
  let oprms =
    let cb = Array.init (mxndx + 1) <| fun i -> uint32 (i + i + 3)
    let rec loopi i =
      let sqri = (i + i) * (i + 3) + 3
      if sqri > mxndx then () else
      if cb.[i] = 0u then loopi (i + 1) else
      let bp = i + i + 3
      let rec cull c = if c > mxndx then () else cb.[c] <- 0u; cull (c + bp)
      cull sqri; loopi (i + 1)
    loopi 0; cb |> Array.filter ((<>) 0u)
  let rec phi x a =
    if a <= 0 then x - (x >>> 1) |> int64 else
    let na = a - 1 in let p = uint64 oprms.[na]
    if x <= p then 1L else phi x na - phi (x / p) na
  phi lmt oprms.Length + int64 oprms.Length

let strt = System.DateTime.Now.Ticks

{ 0 .. 9 } |> Seq.iter (fun i ->
  printfn "π(10**%d) = %d" i (countPrimes (uint64(10. ** i))))

let elpsd = (System.DateTime.Now.Ticks - strt) / 10000L
printfn "This took %d milliseconds." elpsd
