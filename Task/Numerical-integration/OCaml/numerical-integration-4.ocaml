let () =
  List.iter (fun (s,f,lo,hi,n) ->
    Printf.printf "Testing function %s:\n" s;
    List.iter (fun (name,meth) ->
      Printf.printf "  method %s gives %.15g\n" name (integrate f lo hi n meth)
    ) methods
  ) functions
