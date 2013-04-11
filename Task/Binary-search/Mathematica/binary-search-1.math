BinarySearchRecursive[x_List, val_, lo_, hi_] :=
 Module[{mid = lo + Round@((hi - lo)/2)},
  If[hi < lo, Return[-1]];
  Return[
   Which[x[[mid]] > val, BinarySearchRecursive[x, val, lo, mid - 1],
    x[[mid]] < val, BinarySearchRecursive[x, val, mid + 1, hi],
    True, mid]
   ];
  ]
