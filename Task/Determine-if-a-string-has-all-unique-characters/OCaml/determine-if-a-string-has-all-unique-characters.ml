module CMap = Map.Make(struct
  type t = char
  let compare = compare
end)

(** Add index as argument to string.fold_left *)
let string_fold_left_i f acc str =
  snd (String.fold_left
    (fun (index, acc) char -> (index+1, f acc index char))
    (0, acc) str)

exception Found of int * int * char

let has_duplicates str =
  try let _ = string_fold_left_i
    (fun map index char ->
      match CMap.find_opt char map with
        | None -> CMap.add char index map
        | Some i -> raise (Found (i,index,char)))
    CMap.empty str
    in Ok ()
  with Found (i,j,c) -> Error (i,j,c)

let printer str =
  Format.printf "%S (len %d) : " str (String.length str);
  match has_duplicates str with
  | Ok () -> Format.printf "No duplicates.\n"
  | Error (i,j,c) -> Format.printf "Duplicate '%c' (%#x) at %d and %d\n" c (int_of_char c) i j

let () =
  printer "";
  printer ".";
  printer "abcABC";
  printer "XYZ ZYX";
  printer "1234567890ABCDEFGHIJKLMN0PQRSTUVWXYZ"
