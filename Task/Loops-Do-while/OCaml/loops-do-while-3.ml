let v = ref 0 in
do_while (fun () -> incr v; Printf.printf "%d\n" !v)
         (fun () -> !v mod 6 <> 0)
