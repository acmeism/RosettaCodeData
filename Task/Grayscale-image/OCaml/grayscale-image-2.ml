let to_color ~img:gray_channel =
  let width = Bigarray.Array2.dim1 gray_channel
  and height = Bigarray.Array2.dim2 gray_channel in
  let all_channels =
    let kind = Bigarray.int8_unsigned
    and layout = Bigarray.c_layout
    in
    Bigarray.Array3.create kind layout 3 width height
  in
  let r_channel = Bigarray.Array3.slice_left_2 all_channels 0
  and g_channel = Bigarray.Array3.slice_left_2 all_channels 1
  and b_channel = Bigarray.Array3.slice_left_2 all_channels 2
  in
  Bigarray.Array2.blit gray_channel r_channel;
  Bigarray.Array2.blit gray_channel g_channel;
  Bigarray.Array2.blit gray_channel b_channel;
  (all_channels,
   r_channel,
   g_channel,
   b_channel)
