def removeAllButFirst:

  # The hash table functions all expect the hash table to be the input.

  # Is x in the hash table?
  def hashed(x):
    (x|tostring) as $value
    | .[$value] as $bucket
    | $bucket and (.[$value] | index([x]));

  # Add x to the hash table:
  def add_hash(x):
    (x|tostring) as $value
    | .[$value] as $bucket
    | if $bucket and ($bucket | index([x])) then .
      else .[$value] += [x]
      end;

  reduce .[] as $item
    ( [[], {}]; # [array, hash]
      if .[1] | hashed($item) then .
      else [ (.[0] + [$item]), (.[1] | add_hash($item)) ]
      end)
  | .[0];
