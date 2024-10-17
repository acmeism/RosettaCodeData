let uname arg =
  let arg = if arg = "" then "-" else arg in
  let ic = Unix.open_process_in ("uname -" ^ arg) in
  (input_line ic)
;;

# uname "sm";;
- : string = "Linux i686"
