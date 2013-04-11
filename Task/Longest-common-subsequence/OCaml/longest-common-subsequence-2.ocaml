let lcs xs' ys' =
  let xs = Array.of_list xs'
  and ys = Array.of_list ys' in
  let n = Array.length xs
  and m = Array.length ys in
  let a = Array.make_matrix (n+1) (m+1) [] in
  for i = n-1 downto 0 do
    for j = m-1 downto 0 do
      a.(i).(j) <- if xs.(i) = ys.(j) then
                     xs.(i) :: a.(i+1).(j+1)
                   else
                     longest a.(i).(j+1) a.(i+1).(j)
    done
  done;
  a.(0).(0)
