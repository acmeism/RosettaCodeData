// Determine if a string has all unique characters. Nigel Galloway: June 9th., 2020
let fN (n:string)=n.ToCharArray()|>Array.mapi(fun n g->(n,g))|>Array.groupBy(fun (_,n)->n)|>Array.filter(fun(_,n)->n.Length>1)

let allUnique n=match fN n with
                 g when g.Length=0->printfn "All charcters in <<<%s>>> (length %d) are unique" n n.Length
                |g->Array.iter(fun(n,g)->printf "%A is repeated at positions" n; Array.iter(fun(n,_)->printf " %d" n)g;printf " ")g
                    printfn "in <<<%s>>> (length %d)" n n.Length

allUnique ""
allUnique "."
allUnique "abcABC"
allUnique "XYZ ZYX"
allUnique "1234567890ABCDEFGHIJKLMN0PQRSTUVWXYZ"
