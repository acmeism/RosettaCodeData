fun mean_reals [] = 0.0
  | mean_reals xs = foldl op+ 0.0 xs / real (length xs);

val mean_ints = mean_reals o (map real);
