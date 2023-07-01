let persons = [| ("Joe", 120); ("foo", 31); ("bar", 51) |]
Array.sortInPlaceBy fst persons
printfn "%A" persons
