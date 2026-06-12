def faster:
  def digits: [2, 3, 5, 7];
  def wide($max):
    def d: digits[] | select(. <= $max);
    if . == 1 then d | [.]
    else d as $first
    | (. - 1 | wide($max - $first)) as $next
    | [$first] + $next
      end;
  range(2; 7)
  | wide(13)
  | select(add == 13)
  | join("") | tonumber;

count(faster)
