# Input: an array
# Output: the corresponding kolakoski sequence.
# This version of the kolakoski generator is optimized to the extent
# that it avoids storing the full sequence by removing the first item
# in the .s array at each iteration.
def kolakoski:
  foreach cycle as $next ( {s: []};
      # ensure the next element occurs .s[0] times
      .s += [$next]
      | .extra = [range(0; .s[0]-1) as $i | $next]
      | .s = .s[1:] + .extra
      ;
      $next, .extra[] ) ;

def kolakoski($len): limit($len; kolakoski);

def iskolakoski:
  def rle:
    . as $seq
    | reduce range(1;length) as $i ({rle:[], count:1};
        if $seq[$i] == $seq[$i - 1]
        then .count += 1
        else .rle = .rle + [.count]
        | .count = 1
        end)
    | .rle;
  rle | . == .[0 : length] ;
