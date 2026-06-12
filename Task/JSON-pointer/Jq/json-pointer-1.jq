# JSON Pointer

# The characters '~' (%x7E) and '/' (%x2F) have special meanings in JSON Pointer,
# so '~' needs to be encoded as '~0'
# and '/' needs to be encoded as '~1'
# when these characters appear in a reference token.

# The JSON Pointer spec allows 0 both for indexing an array and for retrieving a key named "0".
# disambiguate($k) accordingly disambiguates $k w.r.t. `.`.
# $k should be a string or integer.
# If $k is a string and . is an object then: if has($k) then $k else null end.
# If $k is an integer and . is an array, then emit $k.
# If $k is an integer-valued string and . is an array then exit $k|tonumber.
# Otherwise emit null
def disambiguate( $k ):
  if ($k|type) == "string"
  then if type == "object" then $k
       elif type == "array" and ($k|test("^[0-9]+$"))
       then ($k|tonumber)
       else null
       end
  elif ($k|type) == "number" and type == "array"
  then $k
  else null
  end;

# $array should be an array of strings and integers.
# Emit the disambiguated array, suitable for running getpath/1.
# Emit null if disambiguation fails at any point.
def disambiguatePath($array):
  . as $in
  | reduce $array[] as $x ([];
     if . then . as $path
     | ($in | getpath($path) | disambiguate($x)) as $y
     | if $y then . + [ $y ]
       else null
       end
     else .
     end);

# $p is an array as for getpath
def stepwisegetpath($p):
  if ($p|length) == 0 then .
  else $p[0] as $x
  | if (type == "object" and ($x|type) == "string" and has($x))
    or (type == "array"  and ($x|type) == "number" and $x > -1 and $x < length)
    then .[$x] | stepwisegetpath($p[1:])
    else "JSON Pointer mismatch" | error
    end
  end;

# getjsonpointer() is like jq's getpath() but for jsonpointer pointers,
# and an error condition is raised if there is no value at the location.
def getjsonpointer($pointer):
  if $pointer == "" then .
  elif $pointer[:1] != "/" then "Invalid JSON Pointer: \($pointer)" | error
  else . as $in
  # first decode ~1, then ~0
  | ($pointer | split("/") | .[1:]
     | map(gsub("~1"; "/") | gsub("~0"; "~"))) as $array
  | disambiguatePath($array) as $apath
  | if $apath then stepwisegetpath($apath)
    else "JSON Pointer disambiguation failed: \($pointer)" | error
    end
  end;
