def quibble:
  if length == 0 then ""
  elif length == 1 then .[0]
  else (.[0:length-1] | join(", ")) + " and " + .[length-1]
  end
  | "{" + . + "}";
