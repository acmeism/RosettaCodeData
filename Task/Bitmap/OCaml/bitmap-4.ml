let put_pixel_unsafe (_, r_channel, g_channel, b_channel) (r,g,b) =
  (fun x y ->
    r_channel.{x,y} <- r;
    g_channel.{x,y} <- g;
    b_channel.{x,y} <- b;
  )
