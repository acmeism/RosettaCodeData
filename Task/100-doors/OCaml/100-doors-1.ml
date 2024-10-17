let max_doors = 100

let show_doors =
  Array.iteri (fun i x -> Printf.printf "Door %d is %s\n" (i+1)
                                        (if x then "open" else "closed"))

let flip_doors doors =
  for i = 1 to max_doors do
    let rec flip idx =
      if idx < max_doors then begin
        doors.(idx) <- not doors.(idx);
        flip (idx + i)
      end
    in flip (i - 1)
  done;
  doors

let () =
  show_doors (flip_doors (Array.make max_doors false))
