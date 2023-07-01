fun rms(v: real vector) =
  let
    val v' = Vector.map (fn x => x*x) v
    val sum = Vector.foldl op+ 0.0 v'
  in
    Math.sqrt( sum/real(Vector.length(v')) )
  end;

rms(Vector.tabulate(10, fn n => real(n+1)));
