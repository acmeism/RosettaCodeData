(*
 * Caution: This is my first Ocaml program and anyone with Ocaml experience probably thinks it's horrible
 *          So please don't use this as an example for "good ocaml code" see it more as
 *          "this is what my first lines of ocaml might look like"
 *
 *          The only reason im publishing this is that nobody has yet submitted an example in ocaml
 *)


(* sfp is just a convenience to put a combination if sanitation (s) fire (f) and police (p) department in one record*)
type sfp = {s : int; f : int; p : int}

(* Convenience Function to print a single sfp Record *)
let print_sfp e =
    Printf.printf "%d %d %d\n" e.s e.f e.p

(* Convenience Function to print a list of sfp Records*)
let print_sfp_list l =
    l |> List.iter print_sfp

(* Computes sum of list l *)
let sum l = List.fold_left (+) 0 l

(* checks if element e is in list l *)
let element_in_list e l =
    l |> List.find_map (fun x -> if x == e then Some(e) else None) <> None

(* returns a list with only the unique elements of list l *)
let uniq l =
    let rec uniq_helper acc l =
        match l with
        | [] -> acc
        | h::t -> if element_in_list h t then uniq_helper acc t else uniq_helper (h::acc) t in
    uniq_helper [] l |> List.rev

(* checks wheter or not list l only contains unique elements *)
let is_uniq l = uniq l = l


(* computes all combinations for a given list of sanitation, fire & police departments
   im not very proud of this function...maybe someone with some experience can clean it up? ;)
*)
let department_numbers sl fl pl =
    sl |> List.fold_left (fun aa s ->
        fl |> List.fold_left (fun fa f ->
            pl |> List.fold_left (fun pa p ->
                if
                    sum [s;f;p] == 12 &&
                    is_uniq [s;f;p] then
                        {s = s; f = f; p = p} :: pa
                else
                    pa) []
        |> List.append fa) []
    |> List.append aa) []


(* "main" function *)
let _ =
    let s = [1;2;3;4;5;6;7] in
    let f = [1;2;3;4;5;6;7] in
    let p = [2;4;6] in
    let result = department_numbers s f p in
    print_endline "S F P";
    print_sfp_list result;
