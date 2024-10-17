let swap_rows m i j =
  let tmp = m.(i) in
  m.(i) <- m.(j);
  m.(j) <- tmp;
;;

let rref m =
  try
    let lead = ref 0
    and rows = Array.length m
    and cols = Array.length m.(0) in
    for r = 0 to pred rows do
      if cols <= !lead then
        raise Exit;
      let i = ref r in
      while m.(!i).(!lead) = 0 do
        incr i;
        if rows = !i then begin
          i := r;
          incr lead;
          if cols = !lead then
            raise Exit;
        end
      done;
      swap_rows m !i r;
      let lv = m.(r).(!lead) in
      m.(r) <- Array.map (fun v -> v / lv) m.(r);
      for i = 0 to pred rows do
        if i <> r then
          let lv = m.(i).(!lead) in
          m.(i) <- Array.mapi (fun i iv -> iv - lv * m.(r).(i)) m.(i);
      done;
      incr lead;
    done
  with Exit -> ()
;;

let () =
  let m =
    [| [|  1; 2; -1;  -4 |];
       [|  2; 3; -1; -11 |];
       [| -2; 0; -3;  22 |]; |]
  in
  rref m;

  Array.iter (fun row ->
    Array.iter (fun v ->
      Printf.printf " %d" v
    ) row;
    print_newline()
  ) m
