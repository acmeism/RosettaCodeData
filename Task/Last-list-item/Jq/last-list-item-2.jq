def min_index:
  . as $in
  | reduce range(0; length) as $i ( null;
     $in[$i] as $x
     | if . == null then {ix: 0, min: $x}
       elif $x < .min then {ix: $i, min: $x}
       else . end)
  | .ix;

def task_without_sorting:
  # Output: [min, remainder]
  def remove_min:
     min_index as $ix
     | [.[$ix], (.[:$ix] + .[$ix + 1:])];

  foreach range(1; length) as $i ( {a: .};
       .emit = "Unsorted list: \(.a)\n"
     | (.a | remove_min) as [$m1, $x]
     | ($x | remove_min) as [$m2, $y]
     | ($m1 + $m2) as $sum
     | .emit += "Two smallest: \($m1) + \($m2) = \($sum)"
     | .a = $y + [$sum] ;
     .emit,
   (select(.a|length==1) | "Last item is \(.a[0]).") );

[6, 81, 243, 14, 25, 49, 123, 69, 11]
| task_without_sorting
