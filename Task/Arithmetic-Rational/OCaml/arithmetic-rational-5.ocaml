(* use the module to calculate perfect numbers *)
let () =
   for i = 2 to 1 lsl 19 do
      let sum = ref (Frac.frac 1 i) in
      for factor = 2 to truncate (sqrt (float i)) do
         if i mod factor = 0 then
            Frac.(
            sum := !sum +/ frac 1 factor +/ frac 1 (i / factor)
            )
      done;
      if Frac.is_int !sum then
         Printf.printf "Sum of reciprocal factors of %d = %s exactly %s\n%!"
           i (Frac.to_string !sum) (if Frac.to_string !sum = "1" then "perfect!" else "")
   done
