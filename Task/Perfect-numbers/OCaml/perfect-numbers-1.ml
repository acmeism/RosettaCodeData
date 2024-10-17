let perf n =
  let sum = ref 0 in
    for i = 1 to n-1 do
      if n mod i = 0 then
        sum := !sum + i
    done;
    !sum = n
