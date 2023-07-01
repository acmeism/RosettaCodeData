let () =
  ["abcd"; "123456789"; "abcdef"; "1234567"]
  |> List.rev_map (fun s -> String.length s, s)
  |> List.sort (Fun.flip compare)
  |> List.iter (fun (l, s) -> Printf.printf "%u %s\n" l s)
