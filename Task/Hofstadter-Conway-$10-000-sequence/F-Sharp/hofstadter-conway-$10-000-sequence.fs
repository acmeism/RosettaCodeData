let a = ResizeArray[0; 1; 1]
while a.Count <= (1 <<< 20) do
  a.[a.[a.Count - 1]] + a.[a.Count - a.[a.Count - 1]] |> a.Add
for p = 1 to 19 do
  Seq.max [|for i in 1 <<< p .. 1 <<< p+1 -> float a.[i] / float i|]
  |> printf "Maximum in %6d..%7d is %g\n" (1 <<< p) (1 <<< p+1)
let mallows, _ = a
                 |> List.ofSeq
                 |> List.mapi (fun i n -> i, n)
                 |> List.rev
                 |> List.find (fun (i, n)  -> float(n) / float(i) > 0.55)
printfn "Mallows number is %d" mallows
