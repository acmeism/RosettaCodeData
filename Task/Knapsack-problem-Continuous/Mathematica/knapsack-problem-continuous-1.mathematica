Knapsack[shop_, capacity_] :=  Block[{sortedTable, overN, overW, output},
 sortedTable = SortBy[{#1, #2, #3, #3/#2} & @@@ shop, -#[[4]] &];
 overN = Position[Accumulate[sortedTable[[1 ;;, 2]]], a_ /; a > capacity, 1,1][[1, 1]];
 overW = Accumulate[sortedTable[[1 ;;, 2]]][[overN]] - capacity;

 output = Reverse@sortedTable[[Ordering[sortedTable[[1 ;;, 4]], -overN]]];
 output[[-1, 2]] = output[[-1, 2]] - overW;
 output[[-1, 3]] = output[[-1, 2]] output[[-1, 4]];
 Append[output[[1 ;;, 1 ;; 3]], {"Total",Sequence @@ Total[output[[1 ;;, 2 ;; 3]]]}]]
