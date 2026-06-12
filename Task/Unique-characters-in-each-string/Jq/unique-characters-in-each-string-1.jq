# bag of words
def bow(stream):
  reduce stream as $word ({}; .[($word|tostring)] += 1);

# input: an array of arrays that represent sets
# output: a stream of the items in all the input arrays
def intersections:

  # intersection of (two) sets
  # If a and b are sorted lists, and if all the elements respectively of a and b are distinct,
  # then [a,b] | ios will emit the stream of elements in the set-intersection of a and b.
  def ios:
    .[0] as $a | .[1] as $b
    | if 0 == ($a|length) or 0 == ($b|length) then empty
      elif $a[0] == $b[0] then $a[0], ([$a[1:], $b[1:]] | ios)
      elif $a[0]  < $b[0] then [$a[1:], $b] | ios
      else [$a, $b[1:]] | ios
      end;

   if length == 0 then empty
   elif length == 1 then .[0][]
   elif length == 2 then ios
   elif (.[0]|length) == 0 then empty
   else [.[0], [ .[1:] | intersections]] | ios
   end;
