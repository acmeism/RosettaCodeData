let get_sums ~numbers ~sum =
  let n = Array.length numbers in
  let res = ref [] in
  for i = 0 to n - 2 do
    for j = i + 1 to n - 1 do
      if numbers.(i) + numbers.(j) = sum then
        res := (i, j) :: !res
    done
  done;
  !res


let () =
  let numbers = [| 0; 2; 11; 19; 90 |]
  and sum = 21
  in
  let res = get_sums ~numbers ~sum in

  List.iter (fun (i, j) ->
    Printf.printf "# Found: %d %d\n" i j
  ) res
