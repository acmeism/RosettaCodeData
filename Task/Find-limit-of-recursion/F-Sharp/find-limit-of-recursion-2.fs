let rec recurse n =
   printfn "%d" n
   1 + recurse (n+1)

recurse 0 |> ignore
