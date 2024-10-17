open Num

let get_input () =
   num_of_int (
     try int_of_string Sys.argv.(1)
     with _ -> 10)

let get_max_steps () =
   try int_of_string Sys.argv.(2)
   with _ -> 50

let read_program () =
   let line = read_line () in
   let words = Str.split (Str.regexp " +") line in
   List.map num_of_string words

let is_int n = n =/ (integer_num n)

let run_program num prog =

   let replace n =
      let rec step = function
      | [] -> None
      | h :: t ->
            let n' = h */ n in
            if is_int n' then Some n' else step t in
      step prog in

   let rec repeat m lim =
      Printf.printf "  %s\n" (string_of_num m);
      if lim = 0 then print_endline "Reached max step limit" else
         match replace m with
         | None -> print_endline "Finished"
         | Some x -> repeat x (lim-1)
   in

   let max_steps = get_max_steps () in
   repeat num max_steps

let () =
   let num = get_input () in
   let prog = read_program () in
   run_program num prog
