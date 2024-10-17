let () =
  let img = read_ppm ~filename:"logo.ppm" in
  let img = to_color(to_grayscale ~img) in
  output_ppm ~oc:stdout ~img;
;;
