let stripChars text (chars:string) =
    Array.fold (
        fun (s:string) c -> s.Replace(c.ToString(),"")
    ) text (chars.ToCharArray())

[<EntryPoint>]
let main args =
    printfn "%s" (stripChars "She was a soul stripper. She took my heart!" "aei")
    0
