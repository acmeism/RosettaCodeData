let n=SLPsolve (fE ([1..9]|>List.map(string)) 9 3 3 "sud1.csv")
printSLP ([1..9]|>List.map(string)) (Seq.item 0 n)
