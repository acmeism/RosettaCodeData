(* pre-bake & return an inner-loop function to bin & assemble a character frequency map *)
let get_fproc (m: (char, int) Hashtbl.t) :(char -> unit)  =
  (fun (c:char) -> try
                     Hashtbl.replace m c ( (Hashtbl.find m c) + 1)
                   with Not_found -> Hashtbl.add m c 1)


(* pre-bake and return an inner-loop function to do the actual entropy calculation *)
let get_calc (slen:int) :(float -> float) =
  let slen_float = float_of_int slen in
  let log_2 = log 2.0 in

  (fun v -> let pt = v /. slen_float in
                pt *. ((log pt) /. log_2) )


(* main function, given a string argument it:
       builds a (mutable) frequency map (initial alphabet size of 255, but it's auto-expanding),
       extracts the relative probability values into a list,
       folds-in the basic entropy calculation and returns the result. *)
let shannon (s:string) :float  =
  let freq_hash = Hashtbl.create 255 in
  String.iter (get_fproc freq_hash) s;

  let relative_probs = Hashtbl.fold (fun k v b -> (float v)::b) freq_hash [] in
  let calc = get_calc (String.length s) in

   -1.0 *. List.fold_left (fun b x -> b +. calc x) 0.0 relative_probs
