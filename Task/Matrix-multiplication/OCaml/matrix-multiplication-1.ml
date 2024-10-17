let matrix_multiply x y =
  let x0 = Array.length x
  and y0 = Array.length y in
  let y1 = if y0 = 0 then 0 else Array.length y.(0) in
  let z = Array.make_matrix x0 y1 0 in
  for i = 0 to x0-1 do
    for j = 0 to y1-1 do
      for k = 0 to y0-1 do
        z.(i).(j) <- z.(i).(j) + x.(i).(k) * y.(k).(j)
      done
    done
  done;
  z
