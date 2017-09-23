let primes limit =
  let buf = System.Collections.BitArray(int limit + 1, true)
  let cull p = { p * p .. p .. limit } |> Seq.iter (fun c -> buf.[int c] <- false)
  { 2u .. uint32 (sqrt (double limit)) } |> Seq.iter (fun c -> if buf.[int c] then cull c)
  { 2u .. limit } |> Seq.map (fun i -> if buf.[int i] then i else 0u) |> Seq.filter ((<>) 0u)

[<EntryPoint>]
let main argv =
  if argv = null || argv.Length = 0 then failwith "no command line argument for limit!!!"
  printfn "%A" (primes (System.UInt32.Parse argv.[0]) |> Seq.length)
  0 // return an integer exit code
