let nthHamming n =
  if n < 1UL then failwith "nthHamming; argument must be > 0!"
  if n < 2UL then 0u, 0u, 0u else // trivial case for first value of one
  let lb3 = 1.5849625007211561814537389439478 // Math.Log(3) / Math.Log(2);
  let lb5 = 2.3219280948873623478703194294894 // Math.Log(5) / Math.Log(2);
  let fctr = 6.0 * lb3 * lb5
  let crctn = 2.4534452978042592646620291867186 // Math.Log(Math.sqrt(30.0)) / Math.Log(2.0)
  let lbest = (fctr * double n) ** (1.0/3.0) - crctn // from WP formula
  let lbhi = lbest + 1.0 / lbest
  let lblo = 2.0 * lbest - lbhi // upper and lower bound of upper "band"
  let klmt = uint32 (lbhi / lb5)
  let rec loopk k kcnt kbnd =
    if k > klmt then kcnt, kbnd else
      let p = lbhi - double k * lb5
      let jlmt = uint32 (p / lb3)
      let rec loopj j jcnt jbnd =
        if j > jlmt then loopk (k + 1u) jcnt jbnd else
          let q = p - double j * lb3
          let i = uint32 q
          let lg = lbhi - q + double i // current log 2 value (estimated)
          let nbnd = if lg >= lblo then (lg, (uint32 i, j, k)) :: jbnd else jbnd
          loopj (j + 1u) (jcnt + uint64 i + 1UL) nbnd in loopj 0u kcnt kbnd
  let count, bnd = loopk 0u 0UL [] // 64-bit value so doesn't overflow
  if n > count then failwith "nthHamming:  band high estimate is too low!"
  let ndx = int (count - n)
  if ndx >= bnd.Length then failwith "NthHamming.findNth:  band low estimate is too high!"
  let sbnd = bnd |> List.sortBy (fun (lg, _) -> -lg) // sort in decending order
  let _, rslt = sbnd.[ndx]
  rslt

[<EntryPoint>]
let main argv =
  let topNum = 1000000UL
  printf "( "; {1..20} |> Seq.iter (printf "%A " << trival << nthHamming << uint64); printfn ")"
  printfn "%A" (nthHamming 1691UL |> trival)
  let rslt = nthHammingx topNum
  let strt = System.DateTime.Now.Ticks

  let rslt = nthHamming topNum

  let stop = System.DateTime.Now.Ticks

  let x2, x3, x5 = rslt
  printfn "2**%A times 3**%A times 5**%A" x2 x3 x5
  let lgrthm = log10 2.0 * (double x2 + (double x3 * log 3.0 + double x5 * log 5.0) / log 2.0)
  let exp = floor lgrthm |> int
  let mntsa = 10.0 ** (lgrthm - double exp)
  printfn "Approximately %AE+%A" mntsa exp
  let s = trival rslt |> string
  let lngth = s.Length
  printfn "Digits:  %A" lngth
  if lngth <= 10000 then
    {0..100..lngth-1}
      |> Seq.iter (fun i ->
        printfn "%s" (s.Substring(i, if i + 100 < lngth then 100 else lngth - i)))

  printfn "\r\nFound this last up to %A in %A milliseconds." topNum ((stop - strt) / 10000L)

  printf "\r\nPress any key to exit:"
  System.Console.ReadKey(true) |> ignore
  printfn ""
  0 // return an integer exit code
