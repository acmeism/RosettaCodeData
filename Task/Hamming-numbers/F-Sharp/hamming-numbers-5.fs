let nthHamming n =
  if n < 1UL then failwith "nthHamming:  argument must be > 0!"
  if n < 2UL then 0u, 0u, 0u else // trivial case for first value of one
  let lb3 = 1.5849625007211561814537389439478 // Math.Log(3) / Math.Log(2);
  let lb5 = 2.3219280948873623478703194294894 // Math.Log(5) / Math.Log(2);
  let fctr = 6.0 * lb3 * lb5
  let crctn = 2.4534452978042592646620291867186 // Math.Log(Math.sqrt(30.0)) / Math.Log(2.0)
  let lbest = (fctr * double n) ** (1.0/3.0) - crctn // from WP formula
  let lbhi = lbest + 1.0/lbest
  let lblo = 2.0 * lbest - lbhi // upper and lower bound of upper "band"
  let bglb2 = 1267650600228229401496703205376I
  let bglb3 = 2009178665378409109047848542368I
  let bglb5 = 2943393543170754072109742145491I
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
          let nbnd = if lg < lblo then jbnd else
                       let bglg = bglb2 * bigint i + bglb3 * bigint j + bglb5 * bigint k in
                       (bglg, (uint32 i, j, k)) :: jbnd
          loopj (j + 1u) (jcnt + uint64 i + 1UL) nbnd in loopj 0u kcnt kbnd
  let count, bnd = loopk 0u 0UL [] // 64-bit value so doesn't overflow
  if n > count then failwith "nthHamming:  band high estimate is too low!"
  let ndx = int (count - n)
  if ndx >= bnd.Length then failwith "NthHamming.findNth:  band low estimate is too high!"
  let sbnd = bnd |> List.sortBy (fun (lg, _) -> -lg) // sort in decending order
  let _, rslt = sbnd.[ndx]
  rslt
