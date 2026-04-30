let int_proc p =
  let ret = ref max_int in
  p ret;
  !ret
in
begin
  let rec a k x1 x2 x3 x4 x5 = int_proc @@ fun ra ->
    let k = ref k in
    let rec b() = int_proc @@ fun rb ->
      k := !k - 1;
      ra := a !k b x1 x2 x3 x4;
      rb := !ra
    in
    if !k <= 0 then ra := x4() + x5() else ignore(b())
  in
  print_int (a 10 (fun()-> 1) (fun()-> -1) (fun()-> -1) (fun()-> 1) (fun()-> 0))
end
