let abbrev (table:Table.t) (w:string) : string =
  let w = uppercase_ascii w in
  try
    let e = Table.find { word=w ; min=length w } table in e.word
  with Not_found -> "*error*"

let rec check (table:Table.t) (inputs:string list) : unit =
  List.map (abbrev table) inputs
  |> List.iter (Printf.printf "%s ");
  print_newline ()

let main =
  let table = make_table table_as_string in
  let inputs = ["riG";"rePEAT";"copies";"put";"mo";"rest";"types";"fup.";"6";"poweRin"] in
  check table inputs;
  exit 0
