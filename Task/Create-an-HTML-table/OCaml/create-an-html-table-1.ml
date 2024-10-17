let () =
  let buf = Buffer.create 1 in
  let s = Buffer.add_string buf in
  Random.self_init();
  s "<table>";
  s "<thead align='right'>";
  s "<tr><th></th>";
  List.iter (fun v ->
    s ("<td>" ^ v ^ "</td>")
  ) ["X"; "Y"; "Z"];
  s "</tr>";
  s "</thead>";
  s "<tbody align='right'>";
  for i = 0 to pred 3 do
    s ("<tr><td>" ^ string_of_int i ^ "</td>");
      for j = 0 to pred 3 do
        s ("<td>" ^ string_of_int (Random.int 1000) ^ "</td>");
      done;
    s "</tr>";
  done;
  s "</tbody>";
  s "</table>";
  print_endline (Buffer.contents buf)
