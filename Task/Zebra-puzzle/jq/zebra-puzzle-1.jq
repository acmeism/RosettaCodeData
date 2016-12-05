# Attempt to unify the input object with the specified object
def unify( object ):
  # Attempt to unify the input object with the specified tag:value
  def unify2(tag; value):
    if . == null then null
    elif .[tag] == value then .
    elif .[tag] == null then .[tag] = value
    else null
    end;
  reduce (object|keys[]) as $key
    (.; unify2($key; object[$key]) );

# Input: an array
# Output: if the i-th element can be made to satisfy the condition,
# then the updated array, otherwise empty.
def enforce(i; cond):
  if 0 <= i and i < length
  then
    (.[i] | cond) as $ans
    | if $ans then .[i] = $ans else empty end
  else empty
  end ;
