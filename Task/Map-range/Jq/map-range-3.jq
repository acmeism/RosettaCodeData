def maprange_array(a; b):
  def _helper(a0; b0; factor): b0 + (. - a0) * factor;

  a[0] as $a | b[0] as $b | ((b[1] - b[0]) / (a[1] - a[0])) as $factor
  | map(_helper( $a; $b; $factor) );
