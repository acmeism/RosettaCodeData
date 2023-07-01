(* Task : Vigenère_cipher *)

(*  This is a custom, more functional version of an existing solution,
    due to OCaml 4.05's unsafe-string compatibility mode:
    https://ocaml.org/api/String.html
*)

(*** Helpers ***)

(* Verbose type abbreviation *)
type key = string

(* Rotate a single uppercase letter *)
let ascii_caesar_shift : bool -> char -> char -> char =
    let min_range = Char.code 'A' in
    let max_range = Char.code 'Z' in
    (* aka 26 but this code can be adapted to larger ranges, such as the ASCII printable range (codes 32 to 126). *)
    let range_len = max_range - min_range + 1 in
    let actual_fun (dir : bool) (c1 : char) (c2 : char) : char =
        let n1 = Char.code c1 in
        let n2 = Char.code c2 - min_range in
        let sum = (if dir then (+) else (-)) n1 n2 in
        ( (* Effectively mod function, but simplified and works on negatives. *)
            if sum > max_range
            then sum - range_len
            else if sum < min_range
            then sum + range_len
            else sum
        ) |> Char.chr
    in
    actual_fun

(* Remove non-letters and uppercase *)
let ascii_upper_letters_only (s : string) : string =
    let slen = String.length s in
    (* Make a list of escaped uppercase letter chars *)
    let rec toLetterList sidx acc =
        if sidx >= slen
        then List.rev acc
        else
        let c = s.[sidx] in
        if c >= 'A' && c <= 'Z'
        then toLetterList (sidx + 1) ((c |> Char.escaped) :: acc)
        else if c >= 'a' && c <= 'z'
        then toLetterList (sidx + 1) ((c |> Char.uppercase_ascii |> Char.escaped) :: acc)
        else toLetterList (sidx + 1) acc
    in
    toLetterList 0 [] |> String.concat ""

(*** Actual task at hand ***)

let vig_crypt (dir : bool) (key : key) (message : string) : string =
    let message = ascii_upper_letters_only message in
    let key = ascii_upper_letters_only key in
    let klen = String.length key in
    let aux idx c =
        let kidx = idx mod klen in
        let e = ascii_caesar_shift dir c key.[kidx] in
        e
    in
    String.mapi aux message

let encrypt : key -> string -> string = vig_crypt true
let decrypt : key -> string -> string = vig_crypt false

(*** Output ***)

let () =
  let str = "Beware the Jabberwock, my son! The jaws that bite, \
             the claws that catch!" in
  let key = "VIGENERECIPHER" in
  let ct = encrypt key str in
  let pt = decrypt key ct in
  Printf.printf "Text: %s\n" str;
  Printf.printf "Key:  %s\n" key;
  Printf.printf "Code: %s\n" ct;
  Printf.printf "Back: %s\n" pt
;;
