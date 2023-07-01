val nbr1 = valOf (TextIO.scanStream (Int.scan StringCvt.DEC) TextIO.stdIn);
val nbr2 = valOf (TextIO.scanStream (Int.scan StringCvt.DEC) TextIO.stdIn);
val array = Array2.array (nbr1, nbr2, 0.0);
Array2.update (array, 0, 0, 3.5);
print (Real.toString (Array2.sub (array, 0, 0)) ^ "\n");
