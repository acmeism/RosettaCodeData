let new_img ~width ~height =
  let r_channel, g_channel, b_channel =
    let kind = Bigarray.int8_unsigned
    and layout = Bigarray.c_layout
    in
    (Bigarray.Array2.create kind layout width height,
     Bigarray.Array2.create kind layout width height,
     Bigarray.Array2.create kind layout width height)
  in
  (r_channel,
   g_channel,
   b_channel)
