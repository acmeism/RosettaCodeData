let () =
  while true do
    print_string "Expression: ";
    let str = read_line() in
    if str = "q" then exit 0;
    let expr = read_expression str in
    let res = eval expr in
    Printf.printf " = %g\n%!" res;
  done
