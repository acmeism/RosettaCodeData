let inline numbers n =
    Seq.unfold (fun n -> Some (n, n + LanguagePrimitives.GenericOne)) n
