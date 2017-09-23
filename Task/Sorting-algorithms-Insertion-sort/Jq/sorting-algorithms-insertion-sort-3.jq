def bsearch(target):
  if length == 0 then -1
  elif length == 1 then
     if target == .[0] then 0 elif target < .[0] then -1 else -2 end
  else . as $in
    # state variable: [start, end, answer]
    # where start and end are the upper and lower offsets to use.
      | [0, length-1, null]
      | do_until( .[0] > .[1] ;
                (if .[2] != null then (.[1] = -1) # i.e. break
                 else
                   ( ( (.[1] + .[0]) / 2 ) | floor ) as $mid
                 | $in[$mid] as $monkey
                 | if $monkey == target  then (.[2] = $mid)     # success
                   elif .[0] == .[1]     then (.[1] = -1)       # failure
                   elif $monkey < target then (.[0] = ($mid + 1))
                   else (.[1] = ($mid - 1))
                   end
                 end ))
    | if .[2] == null then # compute the insertion point
         if $in[ .[0] ] < target then (-2 -.[0])
         else (-1 -.[0])
         end
      else .[2]
      end
  end;

# insert x assuming input is sorted
def insert(x):
  if length == 0 then [x]
  else
    bsearch(x) as $i
    | ( if $i < 0 then -(1+$i) else $i end ) as $i
    | .[0:$i] + [x] + .[$i:]
  end ;

def insertion_sort:
   reduce .[] as $x ([]; insert($x));
