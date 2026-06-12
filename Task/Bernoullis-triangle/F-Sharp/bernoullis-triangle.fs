// Bernoulli's triangle. Nigel Galloway: April 17th., 2026
let rec nextrow n g=match n with n :: [] -> [g] | n :: t  -> n + t.Head :: nextrow t g
let BernoulliTri n = List.scan(fun (n,g) _ -> 1 :: nextrow n g,g*2) ([1],2) [1 .. n]|>List.map fst
let rec fN=function n::[]->printfn "%d" n |n::g->printf "%d," n; fN g
BernoulliTri(10)|>List.iter fN
