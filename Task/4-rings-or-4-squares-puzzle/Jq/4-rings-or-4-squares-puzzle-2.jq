# rings/3 assumes that each box (except for the last) has exactly one overlap with its successor.
# Input: ignored.
# Output: a stream of solutions, i.e. a stream of arrays.
# $boxes is an array of boxes, each box being a flat array.
# $min and $max define the range of permissible values of items in the boxes (inclusive)
def rings($boxes; $min; $max):

  def inrange: $min <= . and . <= $max;

  # The following helper function deals with the case when the global per-box sum ($sum) is known.
  # Input: an array representing the solution so far, or null.
  # Output: the input plus the solution corresponding to the first argument.
  # $this is the sum of the previous items in the first box, or 0.
  def solve($boxes; $this; $sum):

    # The following is a helper function for handling the case when:
    # *  $sum is known
    # *  $boxes[0] | length == 1, and
    # *  $boxes|length>1
    def lastInBox($boxes; $this):
      . as $in
      | ($boxes[1:] | (.[0] |= .[1:])) as $bx
      # the first entry in the next box must be the same:
      | ($sum - $this) as $next
      | select($next | inrange)
      | (. + [$next]) | solve( $bx; $next; $sum) ;

    . as $in
    | if $boxes|length == 0 then $in
      else $boxes[0] as $box
      | if $box|length == 0
	then solve( $boxes[1:]; 0; $sum )
        elif $box|length == 1
        # is this the last box?
        then if $boxes|length == 1
             then ($sum - $this) as $next
  	     | select($next | inrange)
  	     | $in + [$next]
             else lastInBox($boxes; $this)
             end
        else # $box|length > 1
        range($min; $max + 1) as $first
        | select( ($this + $first) <= $sum)
        | ($in + [$first]) | solve( [$box[1:]] + $boxes[1:]; $this + $first; $sum)
        end
      end ;

  . as $in
  | $boxes[0] as $box
  | ($boxes[1:] | .[0] |= .[1:]) as $bx
  | [range(0; $box|length) | [range($min; $max + 1)]]
  | combinations
  | solve($bx; .[-1]; add) ;

def count(s): reduce s as $x (null; .+1);
