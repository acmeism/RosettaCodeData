let fill_img ~img:(_, r_channel, g_channel, b_channel) ~color:(r,g,b) =
  Bigarray.Array2.fill r_channel r;
  Bigarray.Array2.fill g_channel g;
  Bigarray.Array2.fill b_channel b;
;;
