let methods = [
  ( "rect_l", fun f x _ -> f x);
  ( "rect_m", fun f x h -> f (x +. h /. 2.) );
  ( "rect_r", fun f x h -> f (x +. h) );
  ( "trap",   fun f x h -> (f x +. f (x +. h)) /. 2. );
  ( "simp",   fun f x h -> (f x +. 4. *. f (x +. h /. 2.) +. f (x +. h)) /. 6. )
]
