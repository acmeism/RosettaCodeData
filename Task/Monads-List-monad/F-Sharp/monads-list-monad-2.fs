// Monads/List monad . Nigel Galloway: March 8th., 2021
List.iter ((+) 1>>(*) 2>>printf "%d ") [3;4;5]; printfn "";;
let pT n=[for i in 1..n do for g in i+1..n do for n in g+1..n do if i*i+g*g=n*n then yield(i,g,n)]
Seq.iter(printf "%A ")(pT 25)
let fN g=match g<10 with false->Error "is greater than 9"|_->Ok g
let fG n=match n>5 with false->Error "is less than 6" |_->Ok n
let valid n=n|>Result.bind fN|>Result.bind fG
let test n=match valid(Ok n) with Ok g->printfn "%d is valid" g|Error e->printfn "Error: %d %s" n e
[5..10]|>List.iter test
