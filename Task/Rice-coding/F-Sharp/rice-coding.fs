// Rice coding. Nigel Galloway: September 21st., 2023
let rec fN g=[match g with 0->() |_->yield 1; yield! fN(g-1)]
let fI n=let rec fI n g=match List.head g with 1->fI (n+1) (List.tail g) |_->(n,List.foldBack(fun i (n,g)->(n*2,g+n*i)) (List.tail g) (1,0)|>snd) in fI 0 n
let rec fG n g=[match n with 1->yield g%2 |_->yield g%2; yield! fG (n-1) (g/2)]
let encode n g=let q=g/pown 2 n in [yield! fN q; yield 0; yield! fG n g|>List.rev]
let decode n g=let a,b=fI g in a*pown 2 n+b
let test=let test=encode 4 in [for n in 0..17 do yield test n] //encode 0 to 17
test|>List.iter(fun n->n|>List.iter(printf "%d"); printf " -> "; printfn "%d" (decode 4 n)) //print the encoded values and the decoded values
