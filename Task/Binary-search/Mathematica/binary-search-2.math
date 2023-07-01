BinarySearch[x_List, val_] := Module[{lo = 1, hi = Length@x, mid},
  While[lo <= hi,
   mid = lo + Round@((hi - lo)/2);
   Which[x[[mid]] > val, hi = mid - 1,
    x[[mid]] < val, lo = mid + 1,
    True, Return[mid]
    ];
   ];
  Return[-1];
  ]
