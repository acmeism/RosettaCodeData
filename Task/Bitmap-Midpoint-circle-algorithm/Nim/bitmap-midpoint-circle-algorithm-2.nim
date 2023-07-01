let raster_circle ~img ~color ~c:(x0, y0) ~r =
  let plot = put_pixel img color in
  let x = 0
  and y = r
  and m = 5 - 4 * r
  in
  let rec loop x y m =
    plot (x0 + x) (y0 + y);
    plot (x0 + y) (y0 + x);
    plot (x0 - x) (y0 + y);
    plot (x0 - y) (y0 + x);
    plot (x0 + x) (y0 - y);
    plot (x0 + y) (y0 - x);
    plot (x0 - x) (y0 - y);
    plot (x0 - y) (y0 - x);
    let y, m =
      if m > 0
      then (y - 1), (m - 8 * y)
      else y, m
    in
    if x <= y then
      let x = x + 1 in
      let m = m + 8 * x + 4 in
      loop x y m
  in
  loop x y m
;;
