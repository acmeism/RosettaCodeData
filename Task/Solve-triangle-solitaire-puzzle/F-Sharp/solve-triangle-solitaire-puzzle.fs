// Solve triangle solitaire puzzle. Nigel Galloway: May 28th., 2024
type hole= O|X
type cand={board:hole[];p2go:int;hist:list<hole[]*int*int*int>}
let G = [0,1,3;0,2,5;1,3,6;1,4,8;2,4,7;2,5,9;3,4,5;3,6,10;3,7,12;4,7,11;4,8,13;5,8,12;5,9,14;6,7,8;7,8,9;10,11,12;11,12,13;12,13,14;3,1,0;5,2,0;6,3,1;8,4,1;7,4,2;9,5,2;5,4,3;10,6,3;12,7,3;11,7,4;13,8,4;12,8,5;14,9,5;8,7,6;9,8,7;12,11,10;13,12,11;14,13,12]
let move n (from,over,To)=let g=Array.copy n.board in g[from]<-O; g[over]<-O; g[To]<-X; {board=g;p2go=n.p2go-1;hist=(n.board,from,over,To)::n.hist}
let moves (p:hole[])=G|>List.fold(fun n g->match g with from,over,To when p[over]=X&&p[from]=X&&p[To]=O->(from,over,To)::n |To,over,from when p[over]=X&&p[from]=X&&p[To]=O->(from,over,To)::n |_->n)[]
let rec fs=function []->None |n::g when n.p2go=0->Some((n.board,-1,-1,-1)::n.hist) |n::g->fs(((moves n.board)|>List.map(fun g->move n g))@g)
let solve n=fs [{board=n; p2go=13; hist=[]}]
let fN(g:hole[])=printfn "    %A\n   %A %A\n  %A %A %A\n %A %A %A %A\n%A %A %A %A %A" g[0] g[1] g[2] g[3] g[4] g[5] g[6] g[7] g[8] g[9] g[10] g[11] g[12] g[13] g[14]
match solve [|O;X;X;X;X;X;X;X;X;X;X;X;X;X;X|] with Some n->n|>List.rev|>List.iter(fun(g,from,over,To)->fN g; if from> -1 then printfn "\nmove from %A over %A to %A\n" from over To) |_->printfn "No solution found"
