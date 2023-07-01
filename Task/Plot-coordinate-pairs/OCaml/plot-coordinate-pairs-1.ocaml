#load "graphics.cma"
open Graphics

let round x = int_of_float (floor(x +. 0.5))

let x = [0; 1; 2; 3; 4; 5; 6; 7; 8; 9]
and y = [2.7; 2.8; 31.4; 38.1; 58.0; 76.2; 100.5; 130.0; 149.3; 180.0]

let () =
  open_graph "";
  List.iter2
    (fun x y ->
      (* scale to fit in the window *)
      let _x = x * 30
      and _y = round(y *. 2.0) in
      plot _x _y)
    x y;
  ignore(wait_next_event [Key_pressed]);
  close_graph();
;;
