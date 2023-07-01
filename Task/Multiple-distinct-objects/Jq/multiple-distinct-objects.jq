def Array(atype; n):
  if   atype == "number" then [ range(0;n) ]
  elif atype == "object" then [ range(0;n)| {"value": . } ]
  elif atype == "array"  then [ range(0;n)| [.] ]
  elif atype == "string" then [ range(0;n)| tostring ]
  elif atype == "boolean" then
    if n == 0 then [] elif n == 1 then [false] elif n==2 then [false, true]
    else error("there are only two boolean values")
    end
  elif atype == "null" then
    if n == 0 then [] elif n == 1 then [null]
    else error("there is only one null value")
    end
  else error("\(atype) is not a jq type")
  end;

# Example:

 Array("object"; 4)
