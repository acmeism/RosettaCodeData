(* Authors: Nicolas Barnier, Pascal Brisset
   Copyright 2004 CENA. All rights reserved.
   This code is distributed under the terms of the GNU LGPL *)

open Facile
open Easy

(* Print a solution *)
let print queens =
  let n = Array.length queens in
  if n <= 10 then (* Pretty printing *)
    for i = 0 to n - 1 do
      let c = Fd.int_value queens.(i) in (* queens.(i) is bound *)
      for j = 0 to n - 1 do
        Printf.printf "%c " (if j = c then '*' else '-')
      done;
      print_newline ()
    done
  else (* Short print *)
    for i = 0 to n-1 do
      Printf.printf "line %d : col %a\n" i Fd.fprint queens.(i)
    done;
  flush stdout;
;;

(* Solve the n-queens problem *)
let queens n =
  (* n decision variables in 0..n-1 *)
  let queens = Fd.array n 0 (n-1) in

  (* 2n auxiliary variables for diagonals *)
  let shift op = Array.mapi (fun i qi -> Arith.e2fd (op (fd2e qi) (i2e i))) queens in
  let diag1 = shift (+~) and diag2 = shift (-~) in

  (* Global constraints *)
  Cstr.post (Alldiff.cstr queens);
  Cstr.post (Alldiff.cstr diag1);
  Cstr.post (Alldiff.cstr diag2);

  (* Heuristic Min Size, Min Value *)
  let h a = (Var.Attr.size a, Var.Attr.min a) in
  let min_min = Goals.Array.choose_index (fun a1 a2 -> h a1 < h a2) in

  (* Search goal *)
  let labeling = Goals.Array.forall ~select:min_min Goals.indomain in

  (* Solve *)
  let bt = ref 0 in
  if Goals.solve ~control:(fun b -> bt := b) (labeling queens) then begin
    Printf.printf "%d backtracks\n" !bt;
    print queens
  end else
    prerr_endline "No solution"

let _ =
  if Array.length Sys.argv <> 2
  then raise (Failure "Usage: queens <nb of queens>");
  Gc.set ({(Gc.get ()) with Gc.space_overhead = 500}); (* May help except with an underRAMed system *)
  queens (int_of_string Sys.argv.(1));;
