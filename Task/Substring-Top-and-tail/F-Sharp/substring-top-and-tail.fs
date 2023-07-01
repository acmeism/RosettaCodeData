[<EntryPoint>]
let main args =
    let s = "一二三四五六七八九十"
    printfn "%A" (s.Substring(1))
    printfn "%A" (s.Substring(0, s.Length - 1))
    printfn "%A" (s.Substring(1, s.Length - 2))
    0
