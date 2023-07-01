cubans|>Seq.take 200|>List.ofSeq|>List.iteri(fun n g->if n%8=7 then printfn "%12s" (cL(g)) else printf "%12s" (cL(g)))
