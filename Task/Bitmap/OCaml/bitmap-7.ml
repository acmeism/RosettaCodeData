let get_dims ~img:(_, r_channel, _, _) =
  let width = Bigarray.Array2.dim1 r_channel
  and height = Bigarray.Array2.dim2 r_channel in
  (width, height)
