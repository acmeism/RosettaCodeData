let fs f s = List.map f s
let f1 n = n * 2
let f2 n = n * n

let fsf1 = fs f1
let fsf2 = fs f2

printfn "%A" (fsf1 [0; 1; 2; 3])
printfn "%A" (fsf1 [2; 4; 6; 8])
printfn "%A" (fsf2 [0; 1; 2; 3])
printfn "%A" (fsf2 [2; 4; 6; 8])
