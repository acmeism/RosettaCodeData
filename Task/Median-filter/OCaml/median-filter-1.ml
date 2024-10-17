let color_add (r1,g1,b1) (r2,g2,b2) =
  ( (r1 + r2),
    (g1 + g2),
    (b1 + b2) )

let color_div (r,g,b) d =
  ( (r / d),
    (g / d),
    (b / d) )

let compare_as_grayscale (r1,g1,b1) (r2,g2,b2) =
  let v1 = (2_126 * r1 +  7_152 * g1 + 722 * b1)
  and v2 = (2_126 * r2 +  7_152 * g2 + 722 * b2) in
  (Pervasives.compare v1 v2)

let get_rgb img x y =
  let _, r_channel,_,_ = img in
  let width = Bigarray.Array2.dim1 r_channel
  and height = Bigarray.Array2.dim2 r_channel in
  if (x < 0) || (x >= width) then (0,0,0) else
  if (y < 0) || (y >= height) then (0,0,0) else  (* feed borders with black *)
  (get_pixel img x y)


let median_value img radius =
  let samples = (radius*2+1) * (radius*2+1) in
  fun x y ->
    let sample = ref [] in

    for _x = (x - radius) to (x + radius) do
      for _y = (y - radius) to (y + radius) do

        let v = get_rgb img _x _y in

        sample := v :: !sample;
      done;
    done;

    let ssample = List.sort compare_as_grayscale !sample in
    let mid = (samples / 2) in

    if (samples mod 2) = 1
    then List.nth ssample (mid+1)
    else
      let median1 = List.nth ssample (mid)
      and median2 = List.nth ssample (mid+1) in
      (color_div (color_add median1 median2) 2)


let median img radius =
  let _, r_channel,_,_ = img in
  let width = Bigarray.Array2.dim1 r_channel
  and height = Bigarray.Array2.dim2 r_channel in

  let _median_value = median_value img radius in

  let res = new_img ~width ~height in
  for y = 0 to pred height do
    for x = 0 to pred width do
      let color = _median_value x y in
      put_pixel res color x y;
    done;
  done;
  (res)
