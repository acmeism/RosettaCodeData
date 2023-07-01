let () =
    let answer = 5I **(int (4I ** (int (3I ** 2))))
    let sans = answer.ToString()
    printfn "Length = %d, digits %s ... %s" sans.Length (sans.Substring(0,20)) (sans.Substring(sans.Length-20))
;;
Length = 183231, digits 62060698786608744707 ... 92256259918212890625
