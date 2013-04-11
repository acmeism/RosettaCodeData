(* ints *)
val a = Array.fromList [1, 2, 3, 4, 5];
Array.foldl op+ 0 a;
Array.foldl op* 1 a;
(* reals *)
val a = Array.fromList [1.0, 2.0, 3.0, 4.0, 5.0];
Array.foldl op+ 0.0 a;
Array.foldl op* 1.0 a;
