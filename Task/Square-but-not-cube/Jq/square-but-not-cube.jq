# Emit an unbounded stream
def squares_not_cubes:
  def icbrt: pow(10; log10/3) | round;
  range(1; infinite)
  | (.*.)
  | icbrt as $c
  | select( ($c*$c*$c) != .);

limit(30; squares_not_cubes)
