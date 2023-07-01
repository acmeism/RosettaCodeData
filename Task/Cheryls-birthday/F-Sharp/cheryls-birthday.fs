//Find Cheryl's Birthday. Nigel Galloway: October 23rd., 2018
type Month = |May |June |July |August
let fN n= n |> List.filter(fun (_,n)->(List.length n) < 2) |> List.unzip
let dates = [(May,15);(May,16);(May,19);(June,17);(June,18);(July,14);(July,16);(August,14);(August,15);(August,17)]
let _,n = dates |> List.groupBy snd |> fN
let   i = n |> List.concat |> List.map fst |> Set.ofList
let _,g = dates |> List.filter(fun (n,_)->not (Set.contains n i)) |> List.groupBy snd |> fN
let _,e = List.concat g |> List.groupBy fst |> fN
printfn "%A" e
