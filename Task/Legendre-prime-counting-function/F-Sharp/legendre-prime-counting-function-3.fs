let masks = Array.init 8 ((<<<) 1uy) // quick bit twiddling

let countPrimes (lmt: uint64): int64 =
  if lmt < 3UL then (if lmt < 2UL then 0L else 1L) else
  let inline half x = (x - 1) >>> 1
  let inline divide nm d = (float nm) / (float d) |> int
  let sqrtlmt = lmt |> float |> sqrt |> uint64
  let mxndx = (sqrtlmt - 1UL) / 2UL |> int in let cbsz = (mxndx + 8) / 8
  let cullbuf = Array.zeroCreate cbsz
  let smalls = Array.init (mxndx + 1) uint32
  let roughs = Array.init (mxndx + 1) <| fun i -> uint32 (i + i + 1)
  let larges = Array.init (mxndx + 1) <| fun i ->
    int64 (lmt / uint64 (i + i + 1) - 1UL) / 2L

  let rec loopbp bp nobps rilmt =
    let i = int (bp - 1UL) >>> 1 in let sqri = (i + i) * (i + 1)
    if sqri > mxndx then nobps, rilmt else
    if (cullbuf.[i >>> 3] &&& masks.[i &&& 7]) <> 0uy then
      loopbp (bp + 2UL) nobps rilmt else
    let w = i >>> 3 in cullbuf.[w] <- cullbuf.[w] ||| masks.[i &&& 7] // cull bp
    { sqri .. int bp .. mxndx } |> Seq.iter (fun c -> // cull multiples of bp...
       let w = c >>> 3 in cullbuf.[w] <- cullbuf.[w] ||| masks.[c &&& 7] )

    // adjust `larges for last partial loop pass;
    // compress larges/roughs for current partial sieve pass...
    let rec loopri iri ori =
      if iri > rilmt then ori - 1 else
      let r = uint64 roughs.[iri] in let sri = int (r >>> 1)
      if (cullbuf.[sri >>> 3] &&& masks.[sri &&& 7]) <> 0uy then
        loopri (iri + 1) ori else // skip for roughs culled this pass!
      let d = bp * r
      larges.[ori] <- larges.[iri] -
                        ( if d <= sqrtlmt then
                            larges.[int smalls.[int (d >>> 1)] - nobps]
                          else let ndx = (half << divide lmt) d
                               int64 smalls.[ndx] ) + int64 nobps
      roughs.[ori] <- uint32 r; loopri (iri + 1) (ori + 1)

    // adjust `smalls` for last partial loop pass...
    let rec loopbpm bpm mxsi =
      if bpm < bp then () else
      let c = smalls.[int (bpm >>> 1)] - uint32 nobps
      let ei = (bpm * bp) >>> 1 |> int
      let rec loopsi si =
        if si < ei then si else smalls.[si] <- smalls.[si] - c; loopsi (si - 1)
      loopbpm (bpm - 2UL) (loopsi mxsi)

    let nrilmt = loopri 0 0
    loopbpm ((sqrtlmt / bp - 1UL) ||| 1UL) mxndx
    loopbp (bp + 2UL) (nobps + 1) nrilmt

  // accumulate result so far; compensate for over subtraction...
  let numobps, mxri = loopbp 3UL 0 mxndx
  let rec smr i acc =
    if i > mxri then // adjust accumulated answer!
      acc + (int64 mxri + 1L + 2L * int64 (numobps - 1)) * int64 mxri / 2L
    else smr (i + 1) (acc - larges.[i])
  let ans0 = smr 1 larges.[0]

  // finally, add result from pairs of rough primes up to cube root of range,
  // where they are two different primes; compensating for over addition...
  let rec loopri ri acc =
    let p = uint64 roughs.[ri] in let q = lmt / p
    let ei = int smalls.[(half << divide q) p] - numobps
    if ei <= ri then acc else
    let rec loopori ori oacc =
      if ori > ei then oacc else
      let ndx = (half << divide q) (uint64 roughs.[ori])
      loopori (ori + 1) (oacc + int64 smalls.[ndx])
    let nacc = loopori (ri + 1) acc // subtract over addition of base primes:
    loopri (ri + 1) (nacc - int64 (ei - ri) * (int64 numobps + int64 ri - 1L))

  loopri 1 ans0 + 1L // add one for only even prime of two!
