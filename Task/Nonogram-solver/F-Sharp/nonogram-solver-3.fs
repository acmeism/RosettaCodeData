let n,i,g,e,l = N.presolve rFile.Value
if l then i |> Array.iter (fun n -> n |> Array.iter (fun n -> printf "%s" (N.toStr n));printfn "") else printfn "No unique solution"
