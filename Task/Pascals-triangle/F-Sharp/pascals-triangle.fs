// Pascal's triangle. Nigel Galloway: April 17th., 2026
let rec nextrow n g=match n with n :: [] -> [g] | n :: t  -> n + t.Head :: nextrow t g
let PascalTri n = List.scan(fun (n,g) _ -> 1 :: nextrow n g,1) ([1],1) [1 .. n]|>List.map fst
let rec fN=function n::[]->printfn "%d" n |n::g->printf "%d," n; fN g
PascalTri(10)|>List.iter fN
