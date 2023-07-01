[<EntryPoint>]
let main args =
    let s = "一二三四五六七八九十"
    let n, m  = 3, 2
    let c = '六'
    let z = "六七八"

    printfn "%s" (s.Substring(n, m))
    printfn "%s" (s.Substring(n))
    printfn "%s" (s.Substring(0, s.Length - 1))
    printfn "%s" (s.Substring(s.IndexOf(c), m))
    printfn "%s" (s.Substring(s.IndexOf(z), m))
    0
