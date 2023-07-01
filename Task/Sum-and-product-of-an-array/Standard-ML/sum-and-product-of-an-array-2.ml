(* ints *)
val x = [1, 2, 3, 4, 5];
foldl op+ 0 x;
foldl op* 1 x;
(* reals *)
val x = [1.0, 2.0, 3.0, 4.0, 5.0];
foldl op+ 0.0 x;
foldl op* 1.0 x;
