def inputOption($prompt; $options):
  def r:
    $prompt | stderr
    | input as $in
      | if $in|test($options) then $in else r end;
  r;

# Inserts item $x in the array input, which is kept sorted as per user input
# assuming it is already sorted.  $q is the prompt number.
# Input: [$q; $a]
# Output: [$qPrime, $aPrime]
def insortRight($x):
  . as [$q, $a]
  | { lo: 0, hi: ($a|length), $q }
  | until( .lo >= .hi;
        ( ((.lo + .hi)/2)|floor) as $mid
        | .q += 1
        | "\(.q): Is \($x) less than \($a[$mid])? y/n: " as $prompt
        | (inputOption($prompt; "[yn]") == "y") as $less
        | if ($less) then .hi = $mid
          else .lo = $mid + 1
          end)
   # insert at position .lo
   | [ .q, ($a[: .lo] + [x] + $a[.lo :]) ];

def order:
  reduce .[] as $item ( [0, []]; insortRight($item) )
  | .[1];

["violet red green indigo blue yellow orange"|splits(" ")]
| order as $ordered
| ("\nThe colors of the rainbow, in sorted order, are:",
    $ordered )
