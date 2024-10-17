# let data = [["a"; "b"; "c"]; [""; "q"; "z"]; ["zap"; "zip"; "Zot"]];;
val data : string list list =
  [["a"; "b"; "c"]; [""; "q"; "z"]; ["zap"; "zip"; "Zot"]]
# sort_table data;;
- : string list list =
[[""; "q"; "z"]; ["a"; "b"; "c"]; ["zap"; "zip"; "Zot"]]
# sort_table ~column:2 data;;
- : string list list =
[["zap"; "zip"; "Zot"]; ["a"; "b"; "c"]; [""; "q"; "z"]]
# sort_table ~column:1 data;;
- : string list list =
[["a"; "b"; "c"]; [""; "q"; "z"]; ["zap"; "zip"; "Zot"]]
# sort_table ~column:1 ~reverse:true data;;
- : string list list =
[["zap"; "zip"; "Zot"]; [""; "q"; "z"]; ["a"; "b"; "c"]]
# sort_table ~ordering:(fun a b -> compare (String.length b) (String.length a)) data;;
- : string list list =
[["zap"; "zip"; "Zot"]; ["a"; "b"; "c"]; [""; "q"; "z"]]
