type histogram = int array

let get_histogram ~img:gray_channel =
  let width = Bigarray.Array2.dim1 gray_channel
  and height = Bigarray.Array2.dim2 gray_channel in
  let t = Array.make 256 0 in
  for x = 0 to pred width do
    for y = 0 to pred height do
      let v = gray_get_pixel_unsafe gray_channel x y in
      t.(v) <- t.(v) + 1;
    done;
  done;
  (t: histogram)
;;
