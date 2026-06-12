// Collect and sort square numbers in ascending order from three lists. Nigel Galloway: December 21st., 2021
let fN g=g*g in printfn "%A" (([3;4;34;25;9;12;36;56;36]@[2;8;81;169;34;55;76;49;7]@[75;121;75;144;35;16;46;35])|>List.filter(fun n->(float>>sqrt>>int>>fN)n=n)|>List.sort)
