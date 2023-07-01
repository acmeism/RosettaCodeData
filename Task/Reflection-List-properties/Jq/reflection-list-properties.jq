# Use jq's built-ins to generate a (recursive) synopsis of .
def synopsis:
  if type == "boolean" then "Type: \(type)"
  elif type == "object"
  then "Type: \(type) length:\(length)",
  (keys_unsorted[] as $k
   | "\($k): \(.[$k] | synopsis )")
  else "Type: \(type) length: \(length)"
  end;

true, null, [1,2], {"a": {"b": 3, "c": 4}, "x": "Rosetta Code"}, now
| ("\n\(.) ::", synopsis)
