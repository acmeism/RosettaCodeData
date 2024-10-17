let v = ref 0
exception Exit_loop
try while true do
  incr v;
  Printf.printf "%d\n" !v;
  if not(!v mod 6 <> 0) then
    raise Exit_loop;
done
with Exit_loop -> ()
