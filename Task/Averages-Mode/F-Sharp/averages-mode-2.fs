> mode ["a"; "b"; "c"; "c"];;
val it : string list = ["c"]
> mode ["a"; "b"; "c"; "c";"a"];;
val it : string list = ["c"; "a"]
> mode [1;2;1;3;2;0;0];;
val it : int list = [0; 2; 1]
