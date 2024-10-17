let shellsort a =
  let len = Array.length a in
  let incSequence = [| 412771; 165103; 66041; 26417; 10567;
                       4231; 1693; 673; 269; 107; 43; 17; 7; 3; 1 |] in

  Array.iter (fun increment ->
    if (increment * 2) <= len then
      for i = increment to pred len do
        let temp = a.(i) in
        let rec loop j =
          if j < 0 || a.(j) <= temp then (j)
          else begin
            a.(j + increment) <- a.(j);
            loop (j - increment)
          end
        in
        let j = loop (i - increment) in
        a.(j + increment) <- temp;
      done;
  ) incSequence;
;;
