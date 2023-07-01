# Convert a jq array path to a JSON Pointer
def jsonpointer:
  def encode: gsub("~"; "~0") | gsub("/"; "~1");
  reduce .[] as $x
    ("";
     if ($x|type) == "string" then "\(.)/\($x|encode)"
     else . + "/\($x)" end );

# Is the input syntactically a jq array path?
def isarraypath:
  type == "array" and
  all(.[]; type == "string" or (type == "number" and floor == .));

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

# getjsonpointer() is like getpath() but for jsonpointer pointers
def getjsonpointer($pointer):
  if $pointer == "" then .  # special case
  else
  # first decode ~1, then ~0
    ($pointer | split("/") | .[1:]
     | map(gsub("~1"; "/") | gsub("~0"; "~"))) as $array
  | disambiguatePath($array) as $apath
  | if $apath then getpath($apath) else null end
  end;

# like getpath() but allow $p to be a jsonpointer or an array
def getpointer($p):
  if ($p|type) == "string" then getjsonpointer($p)
  elif ($p|isarraypath) then getpath($p)
  else $p
  end;

# dereference $pointer, but not recursively.
# $pointer can be a jsonpointer pointer, or a jq array path,
# but one can also call deref(query) where `query` is a jq query yielding a $ref object.
def deref($pointer):
  def resolve($x):
    if ($x | type) == "object"
    then $x["$ref"] as $ref
    | if $ref then getpointer($ref)
      else $x
      end
    else $x
    end;

  if ($pointer|type) == "string"
  then resolve(getpointer($pointer))
  elif ($pointer|isarraypath)
  then resolve(getpath($pointer))
  else resolve($pointer)
  end;
