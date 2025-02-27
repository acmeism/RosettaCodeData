# Are the strings all equal?
def lexically_equal:
  if length <= 1 then true
  else . as $in
  | all( range(0;length-1); $in[0] == $in[. + 1])
  end;

# Are the elements in strictly ascending order?
def lexically_ascending:
  . as $in
  | all( range(0;length-1); $in[.] < $in[. + 1]);
