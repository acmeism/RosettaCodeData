let put_pixel img color x y =
  let _, r_channel,_,_ = img in
  let width = Bigarray.Array2.dim1 r_channel
  and height = Bigarray.Array2.dim2 r_channel in

  if (x < 0) || (x >= width) then invalid_arg "x out of bounds";
  if (y < 0) || (y >= height) then invalid_arg "y out of bounds";

  let r, g, b = color in
  if (r < 0) || (r > 255) then invalid_arg "red out of bounds";
  if (g < 0) || (g > 255) then invalid_arg "green out of bounds";
  if (b < 0) || (b > 255) then invalid_arg "blue out of bounds";

  put_pixel_unsafe img color x y;
;;

let get_pixel ~img ~pt:(x, y) =
  let _, r_channel,_,_ = img in
  let width = Bigarray.Array2.dim1 r_channel
  and height = Bigarray.Array2.dim2 r_channel in
  if (x < 0) || (x >= width) then invalid_arg "x out of bounds";
  if (y < 0) || (y >= height) then invalid_arg "y out of bounds";
  get_pixel_unsafe img x y;
;;
