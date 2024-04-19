let stripChars text (chars:string) =
    Seq.fold (
        fun (s:string) c -> s.Replace(c.ToString(),"")
    ) text chars
printfn "%s" (stripChars "She was a soul stripper. She took my heart!" "aei")
