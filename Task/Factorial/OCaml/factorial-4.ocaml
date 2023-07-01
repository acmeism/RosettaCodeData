let rec factorial n =
  let rec loop acc = function
    | 0 -> acc
    | n -> loop (Z.mul (Z.of_int n) acc) (n - 1)
  in loop Z.one n

let () =
  if not !Sys.interactive then
    begin
      Sys.argv.(1) |> int_of_string |> factorial |> Z.print;
      print_newline ()
    end
