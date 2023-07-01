def circlesort:

  def swap(i;j): .[i] as $t | .[i] = .[j] | .[j] = $t;

  # state: [lo, hi, swaps, array]
  def cs:

    # increment lo, decrement hi, and if they are equal, increment hi again
    # i.e. ++hi if --hi == $lo
    def next: # [lo, hi]
      .[0] += 1 | .[1] -= 1 | (if .[0] == .[1] then .[1] += 1 else . end) ;

    .[0] as $start | .[1] as $stop
    | if $start < $stop then
        until(.[0] >= .[1];
	      .[0] as $lo | .[1] as $hi | .[3] as $array
              | if $array[$lo] > $array[$hi] then
		      .[3] = ($array | swap($lo; $hi))
                    | .[2] += 1         # swaps++
                else .
                end
	      | next)
        | .[0] as $lo | .[1] as $hi
        | [$start, $hi, .[2], .[3]] | cs
	| [$lo, $stop,  .[2], .[3]] | cs
      else .
      end ;

   [0, length-1, 0, .] | cs
   | .[2] as $swaps
   | .[3]
   | if $swaps == 0 then .
      else circlesort
      end ;
