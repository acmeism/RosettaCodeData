let fN jewels stones=stones|>Seq.filter(fun n->Seq.contains n jewels)|>Seq.length
printfn "%d" (fN "aA" "aAAbbbb")
