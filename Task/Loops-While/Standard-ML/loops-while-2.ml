let
  fun loop n =
    if n > 0 then (
      print (Int.toString n ^ "\n");
      loop (n div 2)
    ) else ()
in
  loop 1024
end
