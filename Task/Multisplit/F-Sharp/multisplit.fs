> "a!===b=!=c".Split([|"=="; "!="; "="|], System.StringSplitOptions.None);;
val it : string [] = [|"a"; ""; "b"; ""; "c"|]

> "a!===b=!=c".Split([|"="; "!="; "=="|], System.StringSplitOptions.None);;
val it : string [] = [|"a"; ""; ""; "b"; ""; "c"|]
