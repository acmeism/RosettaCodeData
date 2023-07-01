[<EntryPoint>]
let main args =

    let text = "一二三四五六七八九十"
    let starts = "一二"
    let ends = "九十"
    let contains = "五六"
    let notContains = "百"

    printfn "text = %A" text
    printfn "starts with %A: %A" starts (text.StartsWith(starts))
    printfn "starts with %A: %A" ends (text.StartsWith(ends))
    printfn "ends with %A: %A" ends (text.EndsWith(ends))
    printfn "ends with %A: %A" starts (text.EndsWith(starts))
    printfn "contains %A: %A" contains (text.Contains(contains))
    printfn "contains %A: %A" notContains (text.Contains(notContains))
    printfn "substring %A begins at position %d (zero-based)" contains (text.IndexOf(contains))
    let text2 = text + text
    printfn "text = %A" text2
    Seq.unfold (fun (n : int) ->
            let idx = text2.IndexOf(contains, n)
            if idx < 0 then None else Some (idx, idx+1)) 0
    |> Seq.iter (printfn "substring %A begins at position %d (zero-based)" contains)
    0
