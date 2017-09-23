def binary_digits:
  if . == 0 then 0
  else [recurse( if . == 0 then empty else ./2 | floor end ) % 2 | tostring]
    | reverse
    | .[1:] # remove the leading 0
    | join("")
  end ;
