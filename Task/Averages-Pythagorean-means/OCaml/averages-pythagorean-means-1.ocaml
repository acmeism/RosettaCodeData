let means v =
  let n = Array.length v
  and a = ref 0.0
  and b = ref 1.0
  and c = ref 0.0 in
  for i=0 to n-1 do
    a := !a +. v.(i);
    b := !b *. v.(i);
    c := !c +. 1.0/.v.(i);
  done;
  let nn = float_of_int n in
  (!a /. nn, !b ** (1.0/.nn), nn /. !c)
;;
