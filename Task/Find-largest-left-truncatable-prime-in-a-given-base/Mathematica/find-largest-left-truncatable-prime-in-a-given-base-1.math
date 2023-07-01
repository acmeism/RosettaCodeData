LargestLeftTruncatablePrimeInBase[n_] :=
 Max[NestWhile[{Select[
       Flatten@Outer[Function[{a, b}, #[[2]] a + b],
         Range[1, n - 1], #[[1]]], PrimeQ], n #[[2]]} &, {{0},
     1}, #[[1]] != {} &, 1, Infinity, -1][[1]]]
