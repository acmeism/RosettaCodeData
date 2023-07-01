[2..20000 - 1]
|> List.map (fun n-> n, ([1..n/2] |> List.filter (fun x->n % x = 0) |> List.sum))
|> List.map (fun (a,b) ->if a<b then (a,b) else (b,a))
|> List.groupBy id
|> List.map snd
|> List.filter (List.length >> ((=) 2))
|> List.map List.head
|> List.iter (printfn "%A")
