open Complex

let mean_angle angles =
  let sum =
    List.fold_left (fun sum a -> add sum (polar 1.0 (deg2rad a))) zero angles
  in
    rad2deg (arg sum)
