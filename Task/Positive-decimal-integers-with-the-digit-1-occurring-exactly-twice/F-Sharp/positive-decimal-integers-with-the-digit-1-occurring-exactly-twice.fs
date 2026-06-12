// 3 digit numbers with 2 ones. Nigel Galloway: July 6th., 2021
[0;2;3;4;5;6;7;8;9]|>List.collect(fun g->[[g;1;1];[1;g;1];[1;1;g]])|>List.iter(fun(n::g::l::_)->printf "%d " (n*100+g*10+l)); printfn ""
