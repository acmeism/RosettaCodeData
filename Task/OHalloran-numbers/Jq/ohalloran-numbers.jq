# Emit a stream of possible cuboid areas less than or equal to the specified limit,
# $maxarea, which should be an even integer.
def cuboid_areas(maxarea):
  maxarea as $maxarea
  # min area per face is 1 so if total area is $maxarea, the max dimension is ($maxarea-4)/2
  | ($maxarea/2) as $halfmax
  | ($halfmax - 2) as $max
  | foreach range(1; 1+$max) as $i (null;
      label $loopj
      # By symmetry, we can assume i <= j <= k
      | foreach range($i; 1+$max) as $j (.;
          ($i*$j) as $ij
          | if $ij + 2 > $halfmax then break $loopj else . end
	  | label $loopk
          | foreach range($j; 1+$max) as $k (.;
	      ($ij + $i*$k + $j*$k) as $total
              | if $total > $halfmax then break $loopk
	        else 2 * $total
		end) ) );

1000 as $n
| "Even integers greater than 6 but less than \($n) that cannot be cuboid surface areas:",
  [range(6;$n;2)] - [cuboid_areas($n-2)]
