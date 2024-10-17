let rev_bytes bs =
  let last = Bytes.length bs - 1 in
  for i = 0 to last / 2 do
    let j = last - i in
    let c = Bytes.get bs i in
    Bytes.set bs i (Bytes.get bs j);
    Bytes.set bs j c;
  done

let () =
  let s = Bytes.of_string "Hello World" in
  rev_bytes s;
  print_bytes s;
  print_newline ();
;;
