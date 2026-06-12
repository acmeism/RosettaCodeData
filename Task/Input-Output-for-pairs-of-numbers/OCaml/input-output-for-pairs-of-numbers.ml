let () =
  let n = int_of_string (input_line stdin) in
  for i = 1 to n do
    let line = input_line stdin in
    match String.split_on_char ' ' line with
    | a::b::[] ->
        let x = int_of_string a + int_of_string b in
        print_int x;
        print_newline ()
    | _ ->
        raise (Invalid_argument "wrong input")
  done
