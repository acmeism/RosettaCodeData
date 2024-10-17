let () =
  for candidate = 2 to 1 lsl 19 do
    let sum = ref Num.(1 / of_int candidate) in
    for factor = 2 to truncate (sqrt (float candidate)) do
      if candidate mod factor = 0 then
        sum := Num.(!sum + 1 / of_int factor + of_int factor / of_int candidate)
    done;
    if Num.is_integer_num !sum then
      Printf.printf "Sum of recipr. factors of %d = %d exactly %s\n%!"
        candidate Num.(to_int !sum) (if Num.(!sum = 1) then "perfect!" else "")
  done
