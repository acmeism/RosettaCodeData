# Input: a positive integer
# Output: the "middle-square"
def middle_square:
  (tostring|length) as $len
  | (. * .)
  | tostring
  | (3*length/4|ceil) as $n
  | .[ -$n : $len-$n]
  | if length == 0 then 0 else tonumber end;

# Input: a positive integer
# Output: middle_square, applied recursively
def middle_squares:
  middle_square | ., middle_squares;

limit(5; 675248 | middle_squares)
