(* ints *)
let x = [1; 2; 3; 4; 5];;
List.fold_left (+) 0 x;;
List.fold_left ( * ) 1 x;;
(* floats *)
let x = [1.0; 2.0; 3.0; 4.0; 5.0];;
List.fold_left (+.) 0.0 x;;
List.fold_left ( *.) 1.0 x;;
