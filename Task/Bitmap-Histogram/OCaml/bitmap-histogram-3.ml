let () =
  let img = read_ppm ~filename:"/tmp/foo.ppm" in

  let width, height = get_dims img in
  let res = new_img ~width ~height in

  let g_img = to_grayscale ~img in
  let h = get_histogram g_img in
  let m = histogram_median h in

  let light = (255, 255, 0)
  and dark = (127, 0, 127) in

  for x = 0 to pred width do
    for y = 0 to pred height do
      let v = gray_get_pixel_unsafe g_img x y in
      if v > m
      then put_pixel_unsafe res light x y
      else put_pixel_unsafe res dark x y
    done;
  done;

  output_ppm ~oc:stdout ~img:res;
;;
