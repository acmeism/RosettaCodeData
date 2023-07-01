let sequence steps =
  let sb1 = Buffer.create 100 in
  let sb2 = Buffer.create 100 in
  Buffer.add_char sb1 '0';
  Buffer.add_char sb2 '1';
  for i = 0 to pred steps do
    let tmp = Buffer.contents sb1 in
    Buffer.add_string sb1 (Buffer.contents sb2);
    Buffer.add_string sb2 tmp;
  done;
  (Buffer.contents sb1)

let () =
  print_endline (sequence 6);
