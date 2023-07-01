let TinyPhiPrimes = [| 2; 3; 5; 7; 11; 13 |]
let TinyPhiDeg = TinyPhiPrimes.Length - 1
let TinyPhiOddCirc = (TinyPhiPrimes |> Seq.reduce (*)) / 2
let TinyPhiTot = TinyPhiPrimes |> Seq.fold (fun s p -> s * (p - 1)) 1
let TinyPhiLUT =
  let cb = Array.init TinyPhiOddCirc (fun i -> 1u)
  TinyPhiPrimes |> Seq.skip 1
    |> Seq.iter (fun bp ->
      cb.[(bp - 1) >>> 1] <- 0u
      { (bp * bp - 1) >>> 1 .. bp .. TinyPhiOddCirc - 1}
        |> Seq.iter (fun c -> cb.[c] <- 0u) )
  let rec loopi i acc =
    if i >= TinyPhiOddCirc then () else
    let nacc = acc + cb[i] in cb.[i] <- nacc; loopi (i + 1) nacc
  loopi 0 0u; cb
let tinyPhi (x: uint64): int64 =
  let ndx = (x - 1UL) >>> 1 |> int64
  let numtots = ndx / int64 TinyPhiOddCirc
  let li = ndx - numtots * int64 TinyPhiOddCirc |> int
  numtots * int64 TinyPhiTot + int64 TinyPhiLUT.[li]

let countPrimes (lmt: uint64) =
  if lmt < 169UL then // below 169 whose sqrt is 13 is where TinyPhi doesn't work...
    ( if lmt < 2UL then 0L else
      if lmt < 3UL then 1L else
      // adjust for the missing "degree" base primes
      if lmt < 9UL then 1L + int64 (lmt - 1UL) / 2L else
      if lmt <= 13UL then int64 (lmt - 1UL) / 2L else
      5L + int64 TinyPhiLUT.[int (lmt - 1UL) / 2]) else
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
  let rec lvl pilmt m =
    let rec looppi pi acc =
      if pi >= pilmt then acc else
      let p = uint64 oprms.[pi] in let nm = p * m
      if lmt <= nm * p then acc + int64 (pilmt - pi) else
      let nacc = if pi <= TinyPhiDeg then acc else acc - lvl pi nm
      looppi (pi + 1) (nacc + tinyPhi (lmt / nm))
    looppi TinyPhiDeg 0L
  tinyPhi lmt - lvl oprms.Length 1UL + int64 oprms.Length
