def test:
  (range(0;10)  | "0.0\(.) -> \( 0.01 * . | getScaleFactor)"),
  (range(10;100) | "0.\(.) -> \( 0.01 * . | getScaleFactor)");

test
