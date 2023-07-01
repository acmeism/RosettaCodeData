let test n=
  let t = System.Diagnostics.Stopwatch.StartNew()
  for n in (rareNums n) do printfn "%A" n
  t.Stop()
  printfn "Elapsed Time: %d ms for length %d" t.ElapsedMilliseconds n

[2..17] |> Seq.iter test
