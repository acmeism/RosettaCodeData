# Input: an upper bound, or null for infinite
def steady_squares:
  range(0; . // infinite)
  | tostring as $i
  | select( .*. | tostring | endswith($i));

10000
| steady_squares
