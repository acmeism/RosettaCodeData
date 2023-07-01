# Tokenize the input using the string "escape" as the prefix escape string
def tokenize(separator; escape):

  # Helper functions:
  # mapper/1 is like map/1, but for each element, $e, in the input array,
  # if $e is an array, then it is inserted,
  # otherwise the elements of ($e|f) are inserted.
  def mapper(f): reduce .[] as $e
    ( [];
      if ($e|type) == "array" then . + [$e] else . + ($e | f) end ) ;

  # interpolate x
  def interpolate(x):
    reduce .[] as $i ([]; . +  [$i, x]) | .[0:-1];

  def splitstring(s; twixt):
    if type == "string" then split(s) | interpolate(twixt)
    else .
    end;

  # concatenate sequences of non-null elements:
  def reform:
    reduce .[] as $x ([];
      if $x == null and .[-1] == null then .[0:-1] + ["", null]
      elif $x == null then . + [null]
      elif .[-1] == null then .[0:-1] + [$x]
      else .[0:-1] +  [ .[-1] + $x ]
      end)
    | if .[-1] == null then .[-1] = "" else . end;

  splitstring(escape + escape; [escape])
  | mapper( splitstring( escape + separator; [separator]) )
  | mapper( splitstring( separator; null ) )
  | map( if type == "string" then split(escape) else . end)
  | flatten
  | reform ;
