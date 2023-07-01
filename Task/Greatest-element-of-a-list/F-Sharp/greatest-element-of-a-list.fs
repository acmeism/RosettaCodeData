let N = System.Random()
let G = List.init 10 (fun _->N.Next())
List.iter (printf "%d ") G
printfn "\nMax value of list is %d" (List.max G)
