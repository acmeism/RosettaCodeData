let sattolo_cycle arr =
  for i = Array.length arr - 1 downto 1 do
    let j = Random.int i in
    let temp = arr.(i) in
    arr.(i) <- arr.(j);
    arr.(j) <- temp
  done
