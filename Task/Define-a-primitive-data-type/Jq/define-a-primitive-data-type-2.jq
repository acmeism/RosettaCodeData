def pp:
  if type == "object" and has("type") then "\(.type)::\(.value)"
  else .
  end;
