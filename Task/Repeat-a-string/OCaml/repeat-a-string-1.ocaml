let string_repeat s n =
  let s = Bytes.of_string s in
  let len = Bytes.length s in
  let res = Bytes.create (n * len) in
  for i = 0 to pred n do
    Bytes.blit s 0 res (i * len) len
  done;
  (Bytes.to_string res)
;;
