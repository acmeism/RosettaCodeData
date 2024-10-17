let swap ar i j =
  let tmp = ar.(i) in
  ar.(i) <- ar.(j);
  ar.(j) <- tmp

let stoogesort ar =
  let rec aux i j =
    if ar.(j) < ar.(i) then
      swap ar i j
    else if j - i > 1 then begin
      let t = (j - i + 1) / 3 in
      aux (i) (j-t);
      aux (i+t) (j);
      aux (i) (j-t);
    end
  in
  aux 0 (Array.length ar - 1)
