# If a and b are sorted lists, and if all the elements respectively of a and b are distinct,
# then [a,b] | ios will emit the stream of elements in the set-intersection of a and b.
def ios:
  .[0] as $a | .[1] as $b
  | if 0 == ($a|length) or 0 == ($b|length) then empty
    elif $a[0] == $b[0] then $a[0], ([$a[1:], $b[1:]] | ios)
    elif $a[0]  < $b[0] then [$a[1:], $b] | ios
    else [$a, $b[1:]] | ios
    end ;

# input: an array of arbitrary JSON arrays
# output: their intersection as sets
def intersection:
  def go:
    if length == 1 then (.[0]|unique)
    else [(.[0]|unique), (.[1:] | go)] | [ios]
    end;
  if length == 0 then []
  elif any(.[]; length == 0) then []
  else sort_by(length) | go
  end;
