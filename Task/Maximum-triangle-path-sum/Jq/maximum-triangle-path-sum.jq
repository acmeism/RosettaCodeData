# Usage: TRIANGLE | solve
def solve:

  # update(next) updates the input row of maxima:
  def update(next):
    . as $maxima
    | [ range(0; next|length)
       | next[.] + ([$maxima[.], $maxima[. + 1]] | max) ];

  . as $in
  | reduce range(length -2; -1; -1) as $i
      ($in[-1];  update( $in[$i] ) ) ;
