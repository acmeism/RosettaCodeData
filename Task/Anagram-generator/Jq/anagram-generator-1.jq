def count(stream): reduce stream as $x (0; .+1);

# remove adjacent duplicates
def once(stream):
  foreach stream as $x ({prev: null};
    if $x == .prev then .emit = null else .emit = $x | .prev = $x end;
    select(.emit).emit);

# one-for-one subtraction
# if . and $y are arrays, then emit the array difference, respecting multiplicity;
# similarly if both are strings, emit a string representing the difference.
def minus($y):
  if type == "array"
  then reduce $y[] as $x (.;
    index($x) as $ix
    | if $ix then .[:$ix] + .[$ix+1:] else . end)
  else explode | minus($y|explode) | implode
  end;

# bag of words
def bow(stream):
  reduce stream as $word ({}; .[($word|tostring)] += 1);
