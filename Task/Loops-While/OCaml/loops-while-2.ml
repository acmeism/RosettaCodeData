let rec loop n =
  if n > 0 then begin
    Printf.printf "%d\n" n;
    loop (n / 2)
  end
in loop 1024
