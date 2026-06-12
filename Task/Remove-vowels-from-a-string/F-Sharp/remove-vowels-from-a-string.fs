let stripVowels n=let g=set['a';'e';'i';'o';'u';'A';'E';'I';'O';'U'] in n|>Seq.filter(fun n->not(g.Contains n))|>Array.ofSeq|>System.String
printfn "%s" (stripVowels "Nigel Galloway")
