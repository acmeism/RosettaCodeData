// Validate CUSIP: Nigel Galloway. June 2nd., 2021
let fN=function n when n>47 && n<58->n-48 |n when n>64 && n<91->n-55 |42->36 |64->37 |_->38
let cD(n:string)=(10-(fst((n.[0..7])|>Seq.fold(fun(z,n)g->let g=(fN(int g))*(n+1) in (z+g/10+g%10,(n+1)%2))(0,0)))%10)%10=int(n.[8])-48
["037833100";"17275R102";"38259P508";"594918104";"68389X103";"68389X105"]|>List.iter(fun n->printfn "CUSIP %s is %s" n (if cD n then "valid" else "invalid"))
