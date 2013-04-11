type trit = True | False | Maybe

let t_not = function
  | True -> False
  | False -> True
  | Maybe -> Maybe

let t_and a b = match (a,b) with
   | (True,True) -> True
   | (False,_)  | (_,False) -> False
   | _ -> Maybe

let t_or a b = t_not (t_and (t_not a) (t_not b))

let t_eq a b = match (a,b) with
   | (True,True) | (False,False) -> True
   | (False,True) | (True,False) -> False
   | _ -> Maybe

let t_imply a b = t_or (t_not a) b

let string_of_trit = function
  | True -> "True"
  | False -> "False"
  | Maybe -> "Maybe"

let () =
  let values = [| True; Maybe; False |] in
  let f = string_of_trit in
  Array.iter (fun v -> Printf.printf "Not %s: %s\n" (f v) (f (t_not v))) values;
  print_newline ();
  let print op str =
    Array.iter (fun a ->
      Array.iter (fun b ->
        Printf.printf "%s %s %s: %s\n" (f a) str (f b) (f (op a b))
      ) values
    ) values;
    print_newline ()
  in
  print t_and "And";
  print t_or "Or";
  print t_imply "Then";
  print t_eq "Equiv";
;;
