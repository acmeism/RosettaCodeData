def is_integral:
  if type == "number" then . == floor
  elif type == "array" then
       length == 2 and .[1] == 0 and (.[0] | is_integral)
  else type == "object"
       and .type == "rational"
       and  .q != 0
       and (.q | is_integral)
       and ((.p / .q) | is_integral)
  end ;
