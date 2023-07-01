# Are the strings all equal?
def lexically_equal:
  . as $in
  | reduce range(0;length-1) as $i
      (true; if . then $in[$i] == $in[$i + 1] else false end);

# Are the strings in strictly ascending order?
def lexically_ascending:
  . as $in
  | reduce range(0;length-1) as $i
      (true; if . then $in[$i] < $in[$i + 1] else false end);
