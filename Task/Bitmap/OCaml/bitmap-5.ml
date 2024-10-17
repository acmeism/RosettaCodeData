let get_pixel_unsafe (_, r_channel, g_channel, b_channel) =
  (fun x y ->
    (r_channel.{x,y},
     g_channel.{x,y},
     b_channel.{x,y})
  )
