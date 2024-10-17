let rec product'' l =
    (* We need to do the cross product of our current list and all the others
     * so we define a helper function for that *)
    let rec aux ~acc l1 l2 = match l1, l2 with
    | [], _ | _, [] -> acc
    | h1::t1, h2::t2 ->
        let acc = (h1::h2)::acc in
        let acc = (aux ~acc t1 l2) in
        aux ~acc [h1] t2
    (* now we can do the actual computation *)
    in match l with
    | [] -> []
    | [l1] -> List.map (fun x -> [x]) l1
    | l1::tl ->
        let tail_product = product'' tl in
        aux ~acc:[] l1 tail_product


product'' [[1;2];[3;4]];;
(*- : int list list = [[1; 4]; [2; 4]; [2; 3]; [1; 3]]*)
product'' [[3;4];[1;2]];;
(*- : int list list = [[3; 2]; [4; 2]; [4; 1]; [3; 1]]*)
product'' [[1;2];[]];;
(*- : int list list = []*)
product'' [[];[1;2]];;
(*- : int list list = []*)
product'' [[1776; 1789];[7; 12];[4; 14; 23];[0; 1]];;
(*
- : int list list =

[[1776; 7; 4; 1]; [1776; 12; 4; 1]; [1776; 12; 14; 1]; [1776; 12; 23; 1];
 [1776; 12; 23; 0]; [1776; 12; 14; 0]; [1776; 12; 4; 0]; [1776; 7; 14; 1];
 [1776; 7; 23; 1]; [1776; 7; 23; 0]; [1776; 7; 14; 0]; [1789; 7; 4; 1];
 [1789; 12; 4; 1]; [1789; 12; 14; 1]; [1789; 12; 23; 1]; [1789; 12; 23; 0];
 [1789; 12; 14; 0]; [1789; 12; 4; 0]; [1789; 7; 14; 1]; [1789; 7; 23; 1];
 [1789; 7; 23; 0]; [1789; 7; 14; 0]; [1789; 7; 4; 0]; [1776; 7; 4; 0]]
*)
product'' [[1; 2; 3];[30];[500; 100]];;
(*
- : int list list =

[[1; 30; 500]; [2; 30; 500]; [3; 30; 500]; [3; 30; 100]; [2; 30; 100];
 [1; 30; 100]]
*)
product'' [[1; 2; 3];[];[500; 100]];;
(*- : int list list = []*)
