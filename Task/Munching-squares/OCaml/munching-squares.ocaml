open Graphics

let () =
  open_graph "";
  resize_window 256 256;
  for y = 0 to pred (size_y()) do
    for x = 0 to pred (size_x()) do
      let v = (x lxor y) land 0xFF in
      set_color (rgb v (255 - v) 0);
      plot x y
    done;
  done;
  ignore(read_key())
