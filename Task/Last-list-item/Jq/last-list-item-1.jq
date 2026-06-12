def task_with_sorting:
  foreach range(1; length) as $i ( {a: .};
      .a |= sort
      | .emit = "Sorted list: \(.a)\n"
      | (.a[0] + .a[1]) as $sum
      | .emit += "Two smallest: \(.a[0]) + \(.a[1]) = \($sum)"
      | .a += [$sum]
      | .a |= .[2:] ;
   .emit,
   (select(.a|length==1) | "Last item is \(.a[0]).") );

[6, 81, 243, 14, 25, 49, 123, 69, 11]
| task_with_sorting
