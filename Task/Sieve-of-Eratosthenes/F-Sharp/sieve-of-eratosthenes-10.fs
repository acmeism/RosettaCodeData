let primes limit =
  let lmtb,lmtbsqrt = (limit - 3u) / 2u, (uint32 (sqrt (double limit)) - 3u) / 2u
  let buf = System.Collections.BitArray(int lmtb + 1, true)
  let cull i = let p = i + i + 3u in let s = p * (i + 1u) + i in
               { s .. p .. lmtb } |> Seq.iter (fun c -> buf.[int c] <- false)
  { 0u .. lmtbsqrt } |> Seq.iter (fun i -> if buf.[int i] then cull i )
  let oddprms = { 0u .. lmtb } |> Seq.map (fun i -> if buf.[int i] then i + i + 3u else 0u)
                |> Seq.filter ((<>) 0u)
  seq { yield 2u; yield! oddprms }
