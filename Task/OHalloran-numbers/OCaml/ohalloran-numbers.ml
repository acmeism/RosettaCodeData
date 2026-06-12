let maximum_area = 1000;;
let half_maximum_area = maximum_area / 2;;

let ohalloran_numbers = Array.make half_maximum_area true;;

for length = 1 to maximum_area - 1 do
  for width = 1 to half_maximum_area - 1 do
    for height = 1 to half_maximum_area - 1 do
      let half_area = length * width + length * height + width * height in
      if half_area < half_maximum_area then
        ohalloran_numbers.(half_area) <- false
    done;
  done;
done;;

Printf.printf "Values larger than 6 and less than 1,000 which cannot be the surface area of a cuboid:\n";
for i = 3 to half_maximum_area - 1 do
  if ohalloran_numbers.(i) then
    Printf.printf "%d " (i * 2)
done;
