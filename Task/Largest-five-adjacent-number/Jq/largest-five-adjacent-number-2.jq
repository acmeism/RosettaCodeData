< /dev/random tr -cd '0-9' | head -c 1000 | jq -R '
  # Input: an array
  # Output: a stream of the width-long subarrays
  def windows(width):
    range(0; 1 + length - width)  as $i | .[$i:$i+width];

  def minmax(s):
    reduce s as $x ( {};
      if .min == null then {min: $x, max: $x}
      elif $x < .min then .min = $x
      elif $x > .max then .max = $x else . end);

  explode | minmax(windows(5) | implode | tonumber)
