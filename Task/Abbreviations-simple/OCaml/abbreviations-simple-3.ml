let clean_strings strs =
  List.filter (fun w -> w <> "" && w <> " ") strs

let rec split = function
  | []      -> Table.empty

  | [w]     ->
     Table.singleton { word=w ; min=length w }

  | w::x::t ->
     try
       let m = int_of_string x in
       Table.add { word=uppercase_ascii w ; min=m } (split t)
     with Failure _ ->
       let m = length w in
       Table.add { word=uppercase_ascii w ; min=m } (split (x::t))

let make_table table_as_string =
  split_on_char ' ' table_as_string
  |> clean_strings
  |> split
