let split_with_escaping ~esc ~sep s =
  let len = String.length s in
  let buf = Buffer.create 16 in
  let rec loop i =
    if i = len then [Buffer.contents buf]
    else if s.[i] = esc && i + 1 < len then begin
      Buffer.add_char buf s.[i + 1];
      loop (i + 2)
    end else if s.[i] = sep then begin
      let s = Buffer.contents buf in
      Buffer.clear buf;
      s :: loop (i + 1)
    end else begin
      Buffer.add_char buf s.[i];
      loop (i + 1)
    end
  in
  loop 0
