module Puzzle =
struct
  type t = int array
  let make () =
    [| 15; (* 0: the empty space *)
        0;  1;  2;  3;
        4;  5;  6;  7;
        8;  9; 10; 11;
       12; 13; 14;  |]

  let move p n =
    let hole, i = p.(0), p.(n) in
    p.(0) <- i;
    p.(n) <- hole

  let print p =
    let out = Array.make 16 "   " in
    for i = 1 to 15 do
      out.(p.(i)) <- Printf.sprintf " %2d" i
    done;
    for i = 0 to 15 do
      if (i mod 4) = 0 then print_newline ();
      print_string out.(i);
    done

  let shuffle p n =
    for i = 1 to n do
      move p (1 + Random.int 15)
    done
end

let play () =
  let p = Puzzle.make () in
  Puzzle.shuffle p 20;
  while true do
    Puzzle.print p;
    print_string " > ";
    Puzzle.move p (read_line () |> int_of_string)
  done
