say .(10) given sub (Int $x) { $x < 2 ?? 1 !! $x * &?ROUTINE($x - 1); }
