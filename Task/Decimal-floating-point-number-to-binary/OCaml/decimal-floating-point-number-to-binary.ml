#load "str.cma"
(* Using the interpteter or the compiler:
 *
 * Interpreter:
 *     $ ocaml convert.ml
 *
 * Compiler:
 *     First of all, delete the line '#load "str.cma"'.
 *     Then, using the native compiler:
 *         $ ocmalopt -o convert str.cmxa convert.ml
 *         $ ./convert
 *     Or using ocamlbuild:
 *         $ ocamlbuild -pkg str convert.native
 *         $ ./convert.native
 *)

(* This program converts from any numerical base to any numerical base. *)
(* The numbers are wrapped within a type named 'value'.
 * Ex: Float 23.7
 *     String "1011.110101"
 *
 * Conversion is performed by the function 'convert'.
 * Ex: Convert.convert ~to_base:2 (Convert.Float 23.7)
 *     Convert.convert ~from_base:2 to_base:10 (Convert.String "1011.110101")
 *
 * (Parameter 'from_base' is optional and defaults to 10)
 *)

(* This signature should be located in a separate file 'convert.mli'... *)
module Convert : sig
  type value = | Float of float
               | String of string
  val convert : ?from_base:int -> to_base:int -> value -> value
end =
struct

type value = | Float of float
             | String of string


(* =========================== *)
(* === Auxiliary functions === *)
(* =========================== *)
(* Digits available: 0 to 9 plus A to Z.
 * A base less than 2 does not make sense... Does it?
 * A base greater than 36 would need more letters... *)
let min_base = 2
let max_base = 10 + int_of_char 'Z' - int_of_char 'A' + 1

(* A maximum number of decimal positions just to avoid infinite loops while
 * computing them... I think 30 is enough... *)
let max_decs = 30


(* Convert an integer into the corresponding digit:
 * 0->'0'; ...; 9->'9'; 10->'A'; 11->'B'; etc. *)
let dig_of_int n =
  if n >= 0 && n <= 9
  then char_of_int (int_of_char '0' + n)
  else if n >= 10 && n <= max_base
       then char_of_int (n + int_of_char 'A' - 10)
       else failwith (Printf.sprintf "Incorrect digit: %c" (char_of_int n))


(* Convert a digit into the corresponding integer:
 * '0'->0; ...; '9'->9; 'A'->10; 'B'->11; etc. *)
let int_of_dig c =
  match c with
  | '0' .. '9' -> int_of_char c - int_of_char '0'
  | 'A' .. 'Z' -> int_of_char c - int_of_char 'A' + 10
  | _ -> failwith (Printf.sprintf "Incorrect character: %c" c)


(* A numerical base must be within some limits. *)
let check_base b =
  if b >= min_base && b <= max_base
  then true
  else invalid_arg ("Invalid base " ^ string_of_int b)


(* A number must have its digits within the range [0..b-1] for any base b. *)
let check_number b n =
  let max_digit = dig_of_int (b - 1)
  and str = match n with
            | Float f -> string_of_float f
            | String s -> s
         |> Str.replace_first (Str.regexp "-") ""  (* strip off one sign *)
         |> Str.replace_first (Str.regexp "\\.") "" (* strip off one dot *)
  in
  let rec scan i =
    if i >= String.length str then true
    else
      if str.[i] <= max_digit
      then scan (i + 1)
      else invalid_arg (Printf.sprintf "Invalid digit %c for base %d" str.[i] b)
  in
  scan 0
(* =============================== *)
(* === End Auxiliary functions === *)
(* =============================== *)


(* ============================ *)
(* === Conversion functions === *)
(* ============================ *)
(* Convert a floating point number, which is always base 10, to any base. *)
let conv_float to_base fl =
  let d = abs_float fl in
  let int_part = truncate d in
  let dec_part = d -. float int_part
  in
  let rec ft_int n ls =
    (* Conversion of the integer part. *)
    let quot = n / to_base
    and rest = n mod to_base in
    if quot = 0 then rest :: ls
                else ft_int quot (rest :: ls)
  in
  let rec ft_dec nd x ls =
    (* Conversion of the decimal part. nd is the maximum number of decinals to
     * be computed. *)
    if x = 0. || nd = 0 then List.rev ls
    else let prod = x *. float to_base in
         let intpart = truncate prod in
         ft_dec (nd - 1) (prod -. float intpart) (intpart :: ls)
  in
  let join_digs ls =
    (* Convert integers into digits and join them into a string. *)
    List.map (fun n -> dig_of_int n |> Char.escaped) ls |> String.concat ""
  in
  let sign = if fl < 0. then "-" else "" in
  let left = sign ^ join_digs (ft_int int_part [])
  and right = join_digs (ft_dec max_decs dec_part []) in
  (* Decimal point only if a decimal part exists. *)
  let str = left ^ (if String.length right = 0 then "" else  "." ^ right) in
  if to_base = 10 then Float (float_of_string str)
                  else String str


(* Convert a value from one base to another.
 * Using base 10 as an intermediate conversion. *)
let conv_string from_base to_base st =
  let digs = Str.replace_first (Str.regexp "-") "" st in
  let splitted = Str.split (Str.regexp "\\.") digs in
  let max_weight = String.length (List.hd splitted) - 1
  in
  let intdigs = List.map (Str.split (Str.regexp "")) splitted
             |> List.flatten
             |> List.map (fun s -> int_of_dig s.[0])
  in
  let conv10 w ns =
    List.mapi (fun i n -> float n *. float from_base ** float (w - i)) ns
    |> List.fold_left (+.) 0.
  in
  let sign = if st.[0] = '-' then -1. else 1. in
  let num_b10 = sign *. conv10 max_weight intdigs in
  if to_base = 10 then Float num_b10
                  else conv_float to_base num_b10
(* ================================ *)
(* === End Conversion functions === *)
(* ================================ *)


(* ============================== *)
(* === Conversion starts here === *)
(* ============================== *)
let convert ?(from_base = 10) ~to_base number =
  let _ = check_base from_base && check_base to_base
  and _ = check_number from_base number
  in
  match number, from_base, to_base with
  | (Float fl, fb, tb) when fb = 10 && tb = 10 ->
      number
  | (Float fl, fb, _) when fb = 10 ->
      conv_float to_base fl
  | (Float _, _, _) ->
      invalid_arg "With a float, base of origin is always 10"
  | (String st, _, _) ->
      conv_string from_base to_base st

end  (* of module Convert *)


(* ======================= *)
(* === Some testing... === *)
(* ======================= *)
open Convert
let () =
  let values_both = [
    (10, 2, Float 23.34375, String "10111.01011");
    (10, 2, Float (-23.34375), String "-10111.01011");
    (10, 2, Float 11.90625, String "1011.11101");
    (10, 2, Float (-11.90625), String "-1011.11101");
    (10, 2, Float 0., String "0");
    (2, 16, String "1111", String "F");
    (2, 16, String "-1111", String "-F")
  ]
  and values = [
    (10, 10, String "23.7", Float 23.7);
    (* conversion of Float to base 10 results in the same Float, not a String *)
    (10, 10, Float 23.7, Float 23.7)
  ] in
  let get_float = function
    | Float f -> f
    | _ -> failwith "Incorrect Float..."
  in
  let get_string = function
    | String s -> s
    | _ -> failwith "Incorrect String..."
  in
  let result pred =
    if pred then "PASS" else "FAIL"
  in
  let pretty_print v1 v2 calc =
    match v1, v2 with
    | Float f, String s ->
       Printf.sprintf "%f => %s; expected %s [%s]\n"
                      (get_float v1) (get_string calc) (get_string v2)
                      (result (calc = v2))
    | String s, Float f ->
       Printf.sprintf "%s => %f; expected %f [%s]\n"
                      (get_string v1) (get_float calc) (get_float v2)
                      (result (calc = v2))
    | String s1, String s2 ->
       Printf.sprintf "%s => %s; expected %s [%s]\n"
                      (get_string v1) (get_string calc) (get_string v2)
                      (result (calc = v2))
    | Float f1, Float f2 ->
       Printf.sprintf "%f => %f; expected %f [%s]\n"
                      (get_float v1) (get_float calc) (get_float v2)
                      (result (calc = v2))
  in
  let testit (base1, base2, num1, num2) =
    let calc1 = convert ~from_base:base1 ~to_base:base2 num1 in
    pretty_print num1 num2 calc1
  in
  let testit_both (base1, base2, num1, num2) =
    testit (base1, base2, num1, num2) ^ testit (base2, base1, num2, num1)
  in
  let _ = List.iter (fun tpl -> print_endline (testit_both tpl)) values_both
  and _ = List.iter (fun tpl -> print_endline (testit tpl)) values
  in ()
