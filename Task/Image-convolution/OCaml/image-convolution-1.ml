let get_rgb img x y =
  let _, r_channel,_,_ = img in
  let width = Bigarray.Array2.dim1 r_channel
  and height = Bigarray.Array2.dim2 r_channel in
  if (x < 0) || (x >= width) then (0,0,0) else
  if (y < 0) || (y >= height) then (0,0,0) else  (* feed borders with black *)
  get_pixel img x y


let convolve_get_value img kernel divisor offset = fun x y ->
  let sum_r = ref 0.0
  and sum_g = ref 0.0
  and sum_b = ref 0.0 in

  for i = -1 to 1 do
    for j = -1 to 1 do
      let r, g, b = get_rgb img (x+i) (y+j) in
      sum_r := !sum_r +. kernel.(j+1).(i+1) *. (float r);
      sum_g := !sum_g +. kernel.(j+1).(i+1) *. (float g);
      sum_b := !sum_b +. kernel.(j+1).(i+1) *. (float b);
    done;
  done;
  ( !sum_r /. divisor +. offset,
    !sum_g /. divisor +. offset,
    !sum_b /. divisor +. offset )


let color_to_int (r,g,b) =
  (truncate r,
   truncate g,
   truncate b)

let bounded (r,g,b) =
  ((max 0 (min r 255)),
   (max 0 (min g 255)),
   (max 0 (min b 255)))


let convolve_value ~img ~kernel ~divisor ~offset =
  let _, r_channel,_,_ = img in
  let width = Bigarray.Array2.dim1 r_channel
  and height = Bigarray.Array2.dim2 r_channel in

  let res = new_img ~width ~height in

  let conv = convolve_get_value img kernel divisor offset in

  for y = 0 to pred height do
    for x = 0 to pred width do
      let color = conv x y in
      let color = color_to_int color in
      put_pixel res (bounded color) x y;
    done;
  done;
  (res)
