let optimised_flip_doors doors =
  for i = 1 to int_of_float (sqrt (float_of_int max_doors)) do
    doors.(i*i - 1) <- true
  done;
  doors

let () =
  show_doors (optimised_flip_doors (Array.make max_doors false))
