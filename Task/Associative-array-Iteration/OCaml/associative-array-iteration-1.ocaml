#!/usr/bin/env ocaml

let map = [| ('A', 1); ('B', 2); ('C', 3) |] ;;

(* iterate over pairs *)
Array.iter (fun (k,v) -> Printf.printf "key: %c - value: %d\n" k v) map ;;

(* iterate over keys *)
Array.iter (fun (k,_) -> Printf.printf "key: %c\n" k) map ;;

(* iterate over values *)
Array.iter (fun (_,v) -> Printf.printf "value: %d\n" v) map ;;

(* in functional programming it is often more useful to fold over the elements *)
Array.fold_left (fun acc (k,v) -> acc ^ Printf.sprintf "key: %c - value: %d\n" k v) "Elements:\n" map ;;
