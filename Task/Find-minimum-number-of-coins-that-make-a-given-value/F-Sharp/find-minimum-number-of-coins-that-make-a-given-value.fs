//Find minimum number of coins that make a given value - Nigel Galloway: August 12th., 20
let fN g=let rec fG n g=function h::t->fG((g/h,h)::n)(g%h) t |_->n in fG [] g [200;100;50;20;10;5;2;1]
fN 988|>List.iter(fun(n,g)->printfn "Take %d of %d" n g)
