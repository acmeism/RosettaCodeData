(* ints *)
let a = [| 1; 2; 3; 4; 5 |];;
Array.fold_left (+) 0 a;;
Array.fold_left ( * ) 1 a;;
(* floats *)
let a = [| 1.0; 2.0; 3.0; 4.0; 5.0 |];;
Array.fold_left (+.) 0.0 a;;
Array.fold_left ( *.) 1.0 a;;
