(*  Task: Determine if a string has all the same characters *)

(*  Create a function that determines whether all characters in a string are identical,
    or returns the index of first different character.

    Using the option type here to combine the functionality.
*)
let str_first_diff_char (s : string) : int option =
    let len = String.length s in
    if len = 0
    then None
    else
    let first = s.[0] in
    let rec helper idx =
        if idx >= len
        then None
        else if s.[idx] = first
        then helper (idx + 1)
        else Some idx
    in
    helper 1
;;

(*  Task display: using format of Ada
    Example:

Input = "333", length = 3
 All characters are the same.
Input = ".55", length = 3
 First difference at position 2, character = '5', hex = 16#35#
*)

let format_answer s =
    let first_line = "Input = \"" ^ s ^ "\", length = " ^ (s |> String.length |> string_of_int) in
    let second_line = match str_first_diff_char s with
        | None -> " All characters are the same."
        | Some idx -> Printf.sprintf " First difference at position %d, character = %C, hex = %#x" (idx+1) s.[idx] (Char.code s.[idx])
    in
    print_endline first_line; print_endline second_line
;;

let _ =
    [""; "   "; "2"; "333"; ".55"; "tttTTT"; "4444 444k"]
    |> List.iter format_answer
;;
