let read_ppm ~filename =
  let ic = open_in filename in
  let line = input_line ic in
  if line <> "P6" then invalid_arg "not a P6 ppm file";
  let line = input_line ic in
  let line =
    try if line.[0] = '#'  (* skip comments *)
    then input_line ic
    else line
    with _ -> line
  in
  let width, height =
    Scanf.sscanf line "%d %d" (fun w h -> (w, h))
  in
  let line = input_line ic in
  if line <> "255" then invalid_arg "not a 8 bit depth image";
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
  for y = 0 to pred height do
    for x = 0 to pred width do
      r_channel.{x,y} <- (input_byte ic);
      g_channel.{x,y} <- (input_byte ic);
      b_channel.{x,y} <- (input_byte ic);
    done;
  done;
  close_in ic;
  (all_channels,
   r_channel,
   g_channel,
   b_channel)
