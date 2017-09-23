# Input should be the array to be sorted.
def combsort:

  # As soon as "condition" is true, emit . and stop:
  def do_until(condition; next):
    def u: if condition then . else (next|u) end;
  u;

  def swap(i;j):
    if i==j then . else .[i] as $tmp | .[i] = .[j] | .[j] = $tmp end;

   . as $in
  | length as $length
    # state: [gap, swaps, array] where:
    #   gap is the gap size;
    #   swaps is a boolean flag indicating a swap has occurred,
    #         implying that the array might not be sorted;
    #   array is the current state of the array being sorted
  | [ $length, false, $in ]
  | do_until( .[0] == 1 and .[1] == false;
      # update the gap value for the next "comb":
      ([1, ((.[0] / 1.25) | floor)] | max) as $gap   # minimum gap is 1

      # state: [i, swaps, array]
      | [0, false, .[2]]
      # a single "comb" over the input list:
      | do_until( (.[0] + $gap) >= $length;
          .[0] as $i
          | if .[2][$i] > .[2][$i+$gap] then
              [$i+1, true, (.[2]|swap($i; $i+$gap))]
            else .[0] += 1
            end)
      | .[0] = $gap )
  | .[2] ;
