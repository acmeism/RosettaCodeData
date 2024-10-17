let () =
  let bstr = load_big_file Sys.argv.(1) in
  let len = Bigarray.Array1.dim bstr in
  for i = 0 to pred len do
    let c = bstr.{i} in
    print_char c
  done
