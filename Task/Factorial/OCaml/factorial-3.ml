let factorial n =
  let result = ref 1 in
  for i = 1 to n do
    result := !result * i
  done;
  !result
