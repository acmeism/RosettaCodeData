def binary_digits:
  if . == 0 then 0
  else [recurse( if . == 0 then empty else ./2 | floor end ) % 2 | tostring]
    | reverse
    | .[1:] # remove the leading 0
    | join("")
  end ;

range(1;1000)
| . as $i
| binary_digits
| select(length % 2 == 0)
| (length/2) as $half
| select(.[$half:] == .[:$half])
| [$i, .]
