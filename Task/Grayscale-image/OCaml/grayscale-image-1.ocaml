let to_grayscale ~img:(_, r_channel, g_channel, b_channel) =
  let width = Bigarray.Array2.dim1 r_channel
  and height = Bigarray.Array2.dim2 r_channel in

  let gray_channel =
    let kind = Bigarray.int8_unsigned
    and layout = Bigarray.c_layout
    in
    (Bigarray.Array2.create kind layout width height)
  in
  for y = 0 to pred height do
    for x = 0 to pred width do
      let r = r_channel.{x,y}
      and g = g_channel.{x,y}
      and b = b_channel.{x,y} in
      let v = (2_126 * r +  7_152 * g + 722 * b) / 10_000 in
      gray_channel.{x,y} <- v;
    done;
  done;
  (gray_channel)
