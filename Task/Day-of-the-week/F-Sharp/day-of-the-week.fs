open System

[ 2008 .. 2121 ]
|> List.choose (fun y -> if DateTime(y,12,25).DayOfWeek = DayOfWeek.Sunday then Some(y) else None)
|> printfn "%A"
