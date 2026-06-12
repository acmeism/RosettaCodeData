let is_abc_word (word : string) : bool =
  try
    String.index word 'a'
    |> fun i -> String.index_from word i 'b'
    |> fun i -> String.index_from word i 'c'
    |> ignore; true
  with Not_found -> false

let () =
  In_channel.with_open_text "unixdict.txt" In_channel.input_all
  |> String.split_on_char '\n'
  |> List.filter is_abc_word
  |> String.concat ", "
  |> print_endline
